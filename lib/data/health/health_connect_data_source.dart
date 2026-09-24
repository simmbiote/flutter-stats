import 'dart:io';

import 'package:health/health.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/errors/health_errors.dart';
import '../../features/sync/domain/models.dart';
import 'health_data_source.dart';
import 'permission_catalog.dart';
import 'source_origin_mapper.dart';

class HealthConnectDataSource implements HealthDataSource {
  HealthConnectDataSource({
    Health? health,
    PermissionCatalog catalog = const PermissionCatalog(),
    SourceOriginMapper originMapper = const SourceOriginMapper(),
  }) : _health = health ?? Health(),
       _catalog = catalog,
       _originMapper = originMapper;

  final Health _health;
  final PermissionCatalog _catalog;
  final SourceOriginMapper _originMapper;
  final Map<String, String> _recordTypesById = {};
  bool _configured = false;

  Future<void> _ensureConfigured() async {
    if (_configured) return;
    try {
      await _health.configure();
      _configured = true;
    } catch (error) {
      throw HealthDataSourceException(
        SyncErrorCategory.unavailable,
        message: 'Health Connect could not be initialized.',
        retryable: true,
      );
    }
  }

  @override
  Future<HealthAvailability> checkAvailability() async {
    await _ensureConfigured();
    if (!Platform.isAndroid) return HealthAvailability.unsupported;
    try {
      final status = await _health.getHealthConnectSdkStatus();
      return switch (status) {
        HealthConnectSdkStatus.sdkAvailable => HealthAvailability.available,
        HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired =>
          HealthAvailability.updateRequired,
        HealthConnectSdkStatus.sdkUnavailable =>
          HealthAvailability.notInstalled,
        null => HealthAvailability.unavailable,
      };
    } catch (_) {
      return HealthAvailability.unavailable;
    }
  }

  @override
  Future<ConnectionSnapshot> getPermissionSnapshot({
    List<String>? recordTypes,
  }) async {
    final availability = await checkAvailability();
    if (availability != HealthAvailability.available) {
      return ConnectionSnapshot(
        state: switch (availability) {
          HealthAvailability.notInstalled => ConnectionState.notInstalled,
          HealthAvailability.updateRequired => ConnectionState.updateRequired,
          HealthAvailability.restricted => ConnectionState.restricted,
          HealthAvailability.unsupported => ConnectionState.unavailable,
          HealthAvailability.available => ConnectionState.unknown,
          HealthAvailability.unavailable => ConnectionState.unavailable,
        },
        availability: availability,
        permissions: _emptyPermissions(recordTypes),
      );
    }

    final selected = _selectedDescriptors(recordTypes);
    final permissions = <String, PermissionStatus>{};
    var grantedCount = 0;
    for (final descriptor in selected) {
      final status = await _permissionForDescriptor(descriptor);
      permissions[descriptor.recordType] = status;
      if (status == PermissionStatus.granted) grantedCount++;
    }
    final backgroundAvailable = await _health
        .isHealthDataInBackgroundAvailable();
    final backgroundAuthorized =
        backgroundAvailable &&
        await _health.isHealthDataInBackgroundAuthorized();
    final allGranted = selected.isNotEmpty && grantedCount == selected.length;
    final anyGranted = grantedCount > 0;
    return ConnectionSnapshot(
      state: allGranted
          ? ConnectionState.connected
          : anyGranted
          ? ConnectionState.partiallyAllowed
          : ConnectionState.denied,
      availability: availability,
      permissions: permissions,
      backgroundReadAvailable: backgroundAvailable,
      backgroundReadAuthorized: backgroundAuthorized,
    );
  }

  @override
  Future<ConnectionSnapshot> requestReadPermissions(
    List<String> recordTypes, {
    bool requestBackground = false,
  }) async {
    final availability = await checkAvailability();
    if (availability != HealthAvailability.available) {
      return getPermissionSnapshot(recordTypes: recordTypes);
    }
    final descriptors = _selectedDescriptors(recordTypes);
    final types = descriptors
        .expand((item) => item.healthTypes)
        .toSet()
        .toList();
    try {
      await _health.requestAuthorization(
        types,
        permissions: List<HealthDataAccess>.filled(
          types.length,
          HealthDataAccess.READ,
        ),
      );
      if (requestBackground &&
          await _health.isHealthDataInBackgroundAvailable()) {
        await _health.requestHealthDataInBackgroundAuthorization();
      }
    } catch (_) {
      return ConnectionSnapshot(
        state: ConnectionState.denied,
        availability: availability,
        permissions: _emptyPermissions(recordTypes),
        safeErrorCategory: SyncErrorCategory.permissionDenied,
      );
    }
    return getPermissionSnapshot(recordTypes: recordTypes);
  }

  @override
  Future<void> revokeOrDisconnect() async {
    try {
      await _health.revokePermissions();
    } catch (_) {
      return;
    }
  }

  @override
  Future<void> openPermissionSettings() async {
    final candidates = [Uri.parse('healthconnect://'), Uri.parse('health://')];
    for (final uri in candidates) {
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      } catch (_) {
        // Try the next platform-specific settings URI.
      }
    }
  }

  @override
  Future<SourceReadResult> readInitialWindow({
    required DateTime start,
    required DateTime end,
    required List<String> recordTypes,
  }) async {
    _validateWindow(start, end);
    final descriptors = _selectedDescriptors(recordTypes);
    final records = <HealthRecordSnapshot>[];
    final cursors = <String, String>{};
    for (final descriptor in descriptors) {
      final points = await _health.getHealthDataFromTypes(
        types: descriptor.healthTypes,
        startTime: start,
        endTime: end,
      );
      for (final point in points) {
        final record = _mapPoint(point, descriptor.recordType);
        if (record != null) records.add(record);
      }
      final token = await _health.getChangesToken(
        types: descriptor.healthTypes,
      );
      if (token != null) cursors[descriptor.recordType] = token;
    }
    return SourceReadResult(records: records, cursors: cursors);
  }

  @override
  Future<SourceReadResult> readChanges({
    required Map<String, String> cursors,
    required List<String> recordTypes,
  }) async {
    final descriptors = _selectedDescriptors(recordTypes);
    final changes = <SourceChange>[];
    final nextCursors = <String, String>{};
    var tokenExpired = false;
    for (final descriptor in descriptors) {
      final token = cursors[descriptor.recordType];
      if (token == null || token.isEmpty) continue;
      var currentToken = token;
      var hasMore = true;
      while (hasMore) {
        final response = await _health.getChanges(changesToken: currentToken);
        if (response == null) {
          throw const HealthDataSourceException(
            SyncErrorCategory.temporarilyUnavailable,
            retryable: true,
          );
        }
        if (response.changesTokenExpired) {
          tokenExpired = true;
          break;
        }
        for (final change in response.changes) {
          final mapped = _mapChange(change, descriptor.recordType);
          if (mapped != null) changes.add(mapped);
        }
        currentToken = response.nextChangesToken;
        hasMore = response.hasMore && currentToken.isNotEmpty;
      }
      if (currentToken.isNotEmpty) {
        nextCursors[descriptor.recordType] = currentToken;
      }
    }
    return SourceReadResult(
      changes: changes,
      cursors: nextCursors,
      tokenExpired: tokenExpired,
    );
  }

  Future<PermissionStatus> _permissionForDescriptor(
    PermissionDescriptor descriptor,
  ) async {
    try {
      var allGranted = true;
      for (final type in descriptor.healthTypes) {
        if (!_health.isDataTypeAvailable(type)) {
          return PermissionStatus.unavailable;
        }
        final granted = await _health.hasPermissions(
          [type],
          permissions: const [HealthDataAccess.READ],
        );
        if (granted != true) allGranted = false;
      }
      return allGranted ? PermissionStatus.granted : PermissionStatus.denied;
    } catch (_) {
      return PermissionStatus.unknown;
    }
  }

  List<PermissionDescriptor> _selectedDescriptors(List<String>? recordTypes) {
    if (recordTypes == null || recordTypes.isEmpty) return _catalog.all;
    return recordTypes
        .map(_catalog.byRecordType)
        .whereType<PermissionDescriptor>()
        .toList(growable: false);
  }

  Map<String, PermissionStatus> _emptyPermissions(List<String>? recordTypes) {
    final descriptors = _selectedDescriptors(recordTypes);
    return {
      for (final descriptor in descriptors)
        descriptor.recordType: PermissionStatus.notDeclared,
    };
  }

  SourceChange? _mapChange(HealthChange change, String fallbackRecordType) {
    if (change.type == HealthChangeType.delete) {
      final id = change.recordId;
      if (id == null || id.isEmpty) return null;
      final recordType = _recordTypesById[id] ?? fallbackRecordType;
      return SourceChange(
        identity: HealthRecordIdentity(
          sourcePlatform: 'android_health_connect',
          sourceRecordId: id,
          recordType: recordType,
        ),
        operation: HealthRecordOperation.delete,
      );
    }
    final point = change.dataPoint;
    if (point == null) return null;
    final record = _mapPoint(point, fallbackRecordType);
    if (record == null) return null;
    return SourceChange(
      identity: record.identity,
      operation: HealthRecordOperation.upsert,
      record: record,
    );
  }

  HealthRecordSnapshot? _mapPoint(
    HealthDataPoint point,
    String fallbackRecordType,
  ) {
    final descriptor = _descriptorForHealthType(point.type);
    final recordType = descriptor?.recordType ?? fallbackRecordType;
    final category = descriptor?.category ?? _catalog.categoryFor(recordType);
    final numeric = point.value is NumericHealthValue
        ? (point.value as NumericHealthValue).numericValue
        : null;
    final attributes = <String, dynamic>{};
    if (point.value is WorkoutHealthValue) {
      final workout = point.value as WorkoutHealthValue;
      attributes['workout'] = workout.toString();
    }
    final version = _versionFor(point);
    _recordTypesById[point.uuid] = recordType;
    return HealthRecordSnapshot(
      identity: HealthRecordIdentity(
        sourcePlatform: 'android_health_connect',
        sourceRecordId: point.uuid,
        recordType: recordType,
      ),
      category: category,
      startTime: point.dateFrom.toUtc(),
      endTime: point.dateTo.toUtc(),
      measurement: HealthMeasurement(
        kind: numeric == null ? 'session' : 'numeric',
        value: numeric,
        unit: point.unit.name,
        attributes: attributes,
      ),
      sourceVersion: version,
      sourceName: _originMapper.displaySource(
        sourceName: point.sourceName,
        sourceId: point.sourceId,
      ),
      origin: _originMapper.originFor(
        sourceName: point.sourceName,
        sourceId: point.sourceId,
      ),
      metadata: const {},
    );
  }

  PermissionDescriptor? _descriptorForHealthType(HealthDataType type) {
    for (final descriptor in _catalog.all) {
      if (descriptor.healthTypes.contains(type)) return descriptor;
    }
    return null;
  }

  String _versionFor(HealthDataPoint point) {
    final metadata = point.metadata;
    if (metadata != null) {
      for (final key in ['clientRecordVersion', 'version', 'lastModified']) {
        final value = metadata[key];
        if (value != null) return '$value';
      }
    }
    return '${point.dateTo.toUtc().microsecondsSinceEpoch}:${point.uuid}';
  }

  void _validateWindow(DateTime start, DateTime end) {
    if (end.isBefore(start)) {
      throw const HealthDataSourceException(SyncErrorCategory.invalidData);
    }
  }
}
