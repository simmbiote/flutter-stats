import '../../features/sync/domain/models.dart';
import 'health_data_source.dart';
import 'permission_catalog.dart';

class FakeHealthDataSource implements HealthDataSource {
  FakeHealthDataSource({
    this.available = true,
    this.granted = false,
    this.backgroundAuthorized = true,
    List<HealthRecordSnapshot>? records,
    List<SourceChange>? changes,
  }) : _records = records ?? _demoRecords(),
       _changes = changes ?? <SourceChange>[];

  final bool available;
  bool granted;
  bool backgroundAuthorized;
  final List<HealthRecordSnapshot> _records;
  final List<SourceChange> _changes;
  int readCount = 0;
  int permissionRequestCount = 0;
  List<String>? lastInitialRecordTypes;
  List<String>? lastChangeRecordTypes;

  @override
  Future<HealthAvailability> checkAvailability() async =>
      available ? HealthAvailability.available : HealthAvailability.unavailable;

  @override
  Future<ConnectionSnapshot> getPermissionSnapshot({
    List<String>? recordTypes,
  }) async {
    final catalog = const PermissionCatalog();
    final descriptors = recordTypes == null || recordTypes.isEmpty
        ? catalog.all
        : recordTypes
              .map(catalog.byRecordType)
              .whereType<PermissionDescriptor>()
              .toList();
    return ConnectionSnapshot(
      state: !available
          ? ConnectionState.unavailable
          : granted
          ? ConnectionState.connected
          : ConnectionState.denied,
      availability: available
          ? HealthAvailability.available
          : HealthAvailability.unavailable,
      permissions: {
        for (final descriptor in descriptors)
          descriptor.recordType: !available
              ? PermissionStatus.unavailable
              : granted
              ? PermissionStatus.granted
              : PermissionStatus.denied,
      },
      backgroundReadAvailable: available,
      backgroundReadAuthorized: backgroundAuthorized,
    );
  }

  @override
  Future<ConnectionSnapshot> requestReadPermissions(
    List<String> recordTypes, {
    bool requestBackground = false,
  }) async {
    permissionRequestCount++;
    if (available) {
      granted = true;
      if (requestBackground) backgroundAuthorized = true;
    }
    return getPermissionSnapshot(recordTypes: recordTypes);
  }

  @override
  Future<void> revokeOrDisconnect() async {
    granted = false;
  }

  @override
  Future<void> openPermissionSettings() async {}

  @override
  Future<SourceReadResult> readInitialWindow({
    required DateTime start,
    required DateTime end,
    required List<String> recordTypes,
  }) async {
    readCount++;
    lastInitialRecordTypes = List<String>.of(recordTypes);
    if (!granted) throw StateError('Permission denied');
    final records = _records
        .where((record) {
          return !record.endTime.isBefore(start) &&
              !record.startTime.isAfter(end);
        })
        .toList(growable: false);
    return SourceReadResult(
      records: records,
      cursors: {
        for (final record in records)
          record.identity.recordType:
              'fake-cursor-${record.identity.recordType}',
      },
    );
  }

  @override
  Future<SourceReadResult> readChanges({
    required Map<String, String> cursors,
    required List<String> recordTypes,
  }) async {
    readCount++;
    lastChangeRecordTypes = List<String>.of(recordTypes);
    if (!granted) throw StateError('Permission denied');
    final changes = _changes
        .where((change) => recordTypes.contains(change.identity.recordType))
        .toList(growable: false);
    return SourceReadResult(
      changes: changes,
      cursors: {
        for (final recordType in recordTypes)
          if (cursors.containsKey(recordType))
            recordType: 'fake-cursor-$recordType',
      },
    );
  }
}

List<HealthRecordSnapshot> _demoRecords() {
  final now = DateTime.now().toUtc();
  return [
    HealthRecordSnapshot(
      identity: const HealthRecordIdentity(
        sourcePlatform: 'android_health_connect',
        sourceRecordId: 'demo-steps',
        recordType: 'steps',
      ),
      category: HealthCategory.activity,
      startTime: now.subtract(const Duration(hours: 2)),
      endTime: now,
      measurement: const HealthMeasurement(
        kind: 'numeric',
        value: 1240,
        unit: 'count',
      ),
      sourceVersion: 'demo-1',
      sourceName: 'Demo Health Connect',
      origin: 'unknown',
    ),
    HealthRecordSnapshot(
      identity: const HealthRecordIdentity(
        sourcePlatform: 'android_health_connect',
        sourceRecordId: 'demo-heart-rate',
        recordType: 'heart_rate',
      ),
      category: HealthCategory.vitals,
      startTime: now.subtract(const Duration(minutes: 30)),
      endTime: now.subtract(const Duration(minutes: 29)),
      measurement: const HealthMeasurement(
        kind: 'numeric',
        value: 72,
        unit: 'beats/minute',
      ),
      sourceVersion: 'demo-1',
      sourceName: 'Demo Health Connect',
      origin: 'unknown',
    ),
    HealthRecordSnapshot(
      identity: const HealthRecordIdentity(
        sourcePlatform: 'android_health_connect',
        sourceRecordId: 'demo-sleep',
        recordType: 'sleep',
      ),
      category: HealthCategory.sleep,
      startTime: now.subtract(const Duration(hours: 8)),
      endTime: now.subtract(const Duration(hours: 7)),
      measurement: const HealthMeasurement(
        kind: 'duration',
        value: 60,
        unit: 'minute',
      ),
      sourceVersion: 'demo-1',
      sourceName: 'Demo Health Connect',
      origin: 'unknown',
    ),
    HealthRecordSnapshot(
      identity: const HealthRecordIdentity(
        sourcePlatform: 'android_health_connect',
        sourceRecordId: 'demo-weight',
        recordType: 'weight',
      ),
      category: HealthCategory.bodyMeasurements,
      startTime: now.subtract(const Duration(days: 1)),
      endTime: now.subtract(const Duration(days: 1)),
      measurement: const HealthMeasurement(
        kind: 'numeric',
        value: 72.4,
        unit: 'kilogram',
      ),
      sourceVersion: 'demo-1',
      sourceName: 'Demo Health Connect',
      origin: 'unknown',
    ),
  ];
}
