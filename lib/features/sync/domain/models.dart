import 'dart:convert';

enum HealthCategory { activity, vitals, sleep, bodyMeasurements }

extension HealthCategoryLabel on HealthCategory {
  String get label {
    switch (this) {
      case HealthCategory.activity:
        return 'Activity';
      case HealthCategory.vitals:
        return 'Vitals';
      case HealthCategory.sleep:
        return 'Sleep';
      case HealthCategory.bodyMeasurements:
        return 'Body measurements';
    }
  }
}

enum HealthRecordOperation { upsert, delete }

extension HealthRecordOperationLabel on HealthRecordOperation {
  String get wireName => name;
}

enum PendingOperationState {
  pending,
  sending,
  retryScheduled,
  blocked,
  acknowledged,
}

enum PermissionStatus {
  unknown,
  notDeclared,
  granted,
  denied,
  revoked,
  restricted,
  unavailable,
}

enum ConnectionState {
  unknown,
  unavailable,
  notInstalled,
  updateRequired,
  restricted,
  denied,
  revoked,
  partiallyAllowed,
  connected,
  disconnected,
}

enum HealthAvailability {
  available,
  notInstalled,
  updateRequired,
  restricted,
  unavailable,
  unsupported,
}

enum SyncReceiveState {
  waiting,
  receiving,
  empty,
  blocked,
  paused,
  failed,
  complete,
}

enum SyncSendState {
  waiting,
  sending,
  sent,
  empty,
  blocked,
  retryScheduled,
  failed,
}

enum SyncErrorCategory {
  unavailable,
  permissionDenied,
  permissionRevoked,
  backgroundUnsupported,
  rateLimited,
  temporarilyUnavailable,
  cursorExpired,
  invalidData,
  missingCredential,
  notConfigured,
  authorization,
  validation,
  malformedResponse,
  timeout,
  connection,
  server,
  unknown,
}

class HealthRecordIdentity {
  const HealthRecordIdentity({
    required this.sourcePlatform,
    required this.sourceRecordId,
    required this.recordType,
  });

  final String sourcePlatform;
  final String sourceRecordId;
  final String recordType;

  String get key => '$sourcePlatform|$sourceRecordId|$recordType';

  Map<String, dynamic> toJson() => {
    'source_platform': sourcePlatform,
    'source_record_id': sourceRecordId,
    'record_type': recordType,
  };

  factory HealthRecordIdentity.fromJson(Map<String, dynamic> json) {
    return HealthRecordIdentity(
      sourcePlatform: json['source_platform'] as String,
      sourceRecordId: json['source_record_id'] as String,
      recordType: json['record_type'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HealthRecordIdentity &&
      other.sourcePlatform == sourcePlatform &&
      other.sourceRecordId == sourceRecordId &&
      other.recordType == recordType;

  @override
  int get hashCode => Object.hash(sourcePlatform, sourceRecordId, recordType);
}

class HealthMeasurement {
  const HealthMeasurement({
    required this.kind,
    required this.unit,
    this.value,
    this.attributes = const {},
  });

  final String kind;
  final String unit;
  final num? value;
  final Map<String, dynamic> attributes;

  bool get hasValue => value != null;

  Map<String, dynamic> toJson() => {
    'kind': kind,
    'unit': unit,
    if (value != null) 'value': value,
    if (attributes.isNotEmpty) 'attributes': attributes,
  };

  factory HealthMeasurement.fromJson(Map<String, dynamic> json) {
    final rawValue = json['value'];
    return HealthMeasurement(
      kind: json['kind'] as String? ?? 'unknown',
      unit: json['unit'] as String? ?? 'unknown',
      value: rawValue is num ? rawValue : num.tryParse('$rawValue'),
      attributes: _stringMap(json['attributes']),
    );
  }

  HealthMeasurement copyWith({
    String? kind,
    String? unit,
    num? value,
    Map<String, dynamic>? attributes,
  }) {
    return HealthMeasurement(
      kind: kind ?? this.kind,
      unit: unit ?? this.unit,
      value: value ?? this.value,
      attributes: attributes ?? this.attributes,
    );
  }
}

class HealthRecordSnapshot {
  const HealthRecordSnapshot({
    required this.identity,
    required this.category,
    required this.startTime,
    required this.endTime,
    required this.measurement,
    required this.sourceVersion,
    required this.sourceName,
    this.startOffset,
    this.endOffset,
    this.origin,
    this.metadata = const {},
  });

  final HealthRecordIdentity identity;
  final HealthCategory category;
  final DateTime startTime;
  final DateTime endTime;
  final HealthMeasurement measurement;
  final String sourceVersion;
  final String sourceName;
  final String? startOffset;
  final String? endOffset;
  final String? origin;
  final Map<String, dynamic> metadata;

  void validate() {
    if (identity.sourcePlatform.isEmpty ||
        identity.sourceRecordId.isEmpty ||
        identity.recordType.isEmpty) {
      throw const FormatException('A health record identity is incomplete.');
    }
    if (endTime.isBefore(startTime)) {
      throw const FormatException('A health record ends before it starts.');
    }
    if (measurement.value != null && measurement.unit.isEmpty) {
      throw const FormatException('A numeric health value needs a unit.');
    }
  }

  Map<String, dynamic> toJson() => {
    'record_id': identity.sourceRecordId,
    'source_platform': identity.sourcePlatform,
    'record_type': identity.recordType,
    'category': category.name,
    'start_time': startTime.toUtc().toIso8601String(),
    'end_time': endTime.toUtc().toIso8601String(),
    if (startOffset != null) 'start_offset': startOffset,
    if (endOffset != null) 'end_offset': endOffset,
    'source_version': sourceVersion,
    'source': sourceName,
    if (origin != null) 'origin': origin,
    'measurement': measurement.toJson(),
    if (metadata.isNotEmpty) 'metadata': metadata,
  };

  factory HealthRecordSnapshot.fromJson(Map<String, dynamic> json) {
    final record = HealthRecordSnapshot(
      identity: HealthRecordIdentity(
        sourcePlatform:
            json['source_platform'] as String? ?? 'android_health_connect',
        sourceRecordId: json['record_id'] as String,
        recordType: json['record_type'] as String,
      ),
      category: HealthCategory.values.firstWhere(
        (value) => value.name == json['category'],
        orElse: () => HealthCategory.activity,
      ),
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      measurement: HealthMeasurement.fromJson(
        Map<String, dynamic>.from(json['measurement'] as Map),
      ),
      sourceVersion: json['source_version'] as String? ?? 'unknown',
      sourceName: json['source'] as String? ?? 'unknown',
      startOffset: json['start_offset'] as String?,
      endOffset: json['end_offset'] as String?,
      origin: json['origin'] as String?,
      metadata: _stringMap(json['metadata']),
    );
    record.validate();
    return record;
  }
}

class SyncCursor {
  const SyncCursor({
    required this.recordType,
    required this.token,
    required this.updatedAt,
  });

  final String recordType;
  final String token;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
    'record_type': recordType,
    'token': token,
    'updated_at': updatedAt.toUtc().toIso8601String(),
  };
}

class SourceChange {
  const SourceChange({
    required this.identity,
    required this.operation,
    this.record,
    this.nextToken,
    this.hasMore = false,
    this.tokenExpired = false,
  });

  final HealthRecordIdentity identity;
  final HealthRecordOperation operation;
  final HealthRecordSnapshot? record;
  final String? nextToken;
  final bool hasMore;
  final bool tokenExpired;

  factory SourceChange.fromHealthChange({
    required HealthRecordIdentity identity,
    required HealthRecordOperation operation,
    HealthRecordSnapshot? record,
    String? nextToken,
    bool hasMore = false,
    bool tokenExpired = false,
  }) {
    return SourceChange(
      identity: identity,
      operation: operation,
      record: record,
      nextToken: nextToken,
      hasMore: hasMore,
      tokenExpired: tokenExpired,
    );
  }
}

class SourceReadResult {
  const SourceReadResult({
    this.records = const [],
    this.changes = const [],
    this.cursors = const {},
    this.tokenExpired = false,
  });

  final List<HealthRecordSnapshot> records;
  final List<SourceChange> changes;
  final Map<String, String> cursors;
  final bool tokenExpired;
}

class PendingOperation {
  const PendingOperation({
    required this.operationId,
    required this.identity,
    required this.operation,
    required this.state,
    required this.createdAt,
    this.payload,
    this.attempts = 0,
    this.nextAttemptAt,
    this.lastErrorCategory,
    this.leaseUntil,
  });

  final String operationId;
  final HealthRecordIdentity identity;
  final HealthRecordOperation operation;
  final PendingOperationState state;
  final DateTime createdAt;
  final HealthRecordSnapshot? payload;
  final int attempts;
  final DateTime? nextAttemptAt;
  final SyncErrorCategory? lastErrorCategory;
  final DateTime? leaseUntil;

  bool get isUpsert => operation == HealthRecordOperation.upsert;

  void validate() {
    if (operationId.isEmpty) {
      throw const FormatException('An operation ID is required.');
    }
    if (isUpsert && payload == null) {
      throw const FormatException('An upsert requires a payload.');
    }
    if (!isUpsert && payload != null) {
      throw const FormatException('A delete must not contain a payload.');
    }
    payload?.validate();
  }

  PendingOperation copyWith({
    PendingOperationState? state,
    HealthRecordSnapshot? payload,
    int? attempts,
    DateTime? nextAttemptAt,
    SyncErrorCategory? lastErrorCategory,
    DateTime? leaseUntil,
    bool clearNextAttemptAt = false,
    bool clearLastError = false,
    bool clearLease = false,
  }) {
    return PendingOperation(
      operationId: operationId,
      identity: identity,
      operation: operation,
      state: state ?? this.state,
      createdAt: createdAt,
      payload: payload ?? this.payload,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: clearNextAttemptAt
          ? null
          : nextAttemptAt ?? this.nextAttemptAt,
      lastErrorCategory: clearLastError
          ? null
          : lastErrorCategory ?? this.lastErrorCategory,
      leaseUntil: clearLease ? null : leaseUntil ?? this.leaseUntil,
    );
  }

  Map<String, dynamic> toJson() => {
    'operation_id': operationId,
    'identity': identity.toJson(),
    'operation': operation.name,
    'state': state.name,
    'created_at': createdAt.toUtc().toIso8601String(),
    if (payload != null) 'payload': payload!.toJson(),
    'attempts': attempts,
    if (nextAttemptAt != null)
      'next_attempt_at': nextAttemptAt!.toUtc().toIso8601String(),
    if (lastErrorCategory != null)
      'last_error_category': lastErrorCategory!.name,
    if (leaseUntil != null)
      'lease_until': leaseUntil!.toUtc().toIso8601String(),
  };

  factory PendingOperation.fromJson(Map<String, dynamic> json) {
    final operation = HealthRecordOperation.values.firstWhere(
      (value) => value.name == json['operation'],
    );
    final payloadJson = json['payload'];
    return PendingOperation(
      operationId: json['operation_id'] as String,
      identity: HealthRecordIdentity.fromJson(
        Map<String, dynamic>.from(json['identity'] as Map),
      ),
      operation: operation,
      state: PendingOperationState.values.firstWhere(
        (value) => value.name == json['state'],
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      payload: payloadJson is Map
          ? HealthRecordSnapshot.fromJson(
              Map<String, dynamic>.from(payloadJson),
            )
          : null,
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      nextAttemptAt: _parseDate(json['next_attempt_at']),
      lastErrorCategory: _parseError(json['last_error_category']),
      leaseUntil: _parseDate(json['lease_until']),
    );
  }

  String encode() => jsonEncode(toJson());

  factory PendingOperation.decode(String value) =>
      PendingOperation.fromJson(jsonDecode(value) as Map<String, dynamic>);
}

class ConnectionSnapshot {
  const ConnectionSnapshot({
    required this.state,
    required this.availability,
    required this.permissions,
    this.backgroundReadAvailable = false,
    this.backgroundReadAuthorized = false,
    this.updatedAt,
    this.safeErrorCategory,
  });

  final ConnectionState state;
  final HealthAvailability availability;
  final Map<String, PermissionStatus> permissions;
  final bool backgroundReadAvailable;
  final bool backgroundReadAuthorized;
  final DateTime? updatedAt;
  final SyncErrorCategory? safeErrorCategory;

  bool get canRead =>
      state == ConnectionState.connected ||
      state == ConnectionState.partiallyAllowed;

  Map<String, dynamic> toJson() => {
    'state': state.name,
    'availability': availability.name,
    'permissions': permissions.map((key, value) => MapEntry(key, value.name)),
    'background_read_available': backgroundReadAvailable,
    'background_read_authorized': backgroundReadAuthorized,
    if (updatedAt != null) 'updated_at': updatedAt!.toUtc().toIso8601String(),
    if (safeErrorCategory != null)
      'safe_error_category': safeErrorCategory!.name,
  };

  factory ConnectionSnapshot.fromJson(Map<String, dynamic> json) {
    final rawPermissions = Map<String, dynamic>.from(
      json['permissions'] as Map? ?? const {},
    );
    return ConnectionSnapshot(
      state: ConnectionState.values.firstWhere(
        (value) => value.name == json['state'],
        orElse: () => ConnectionState.unknown,
      ),
      availability: HealthAvailability.values.firstWhere(
        (value) => value.name == json['availability'],
        orElse: () => HealthAvailability.unsupported,
      ),
      permissions: rawPermissions.map(
        (key, value) => MapEntry(
          key,
          PermissionStatus.values.firstWhere(
            (item) => item.name == value,
            orElse: () => PermissionStatus.unknown,
          ),
        ),
      ),
      backgroundReadAvailable:
          json['background_read_available'] as bool? ?? false,
      backgroundReadAuthorized:
          json['background_read_authorized'] as bool? ?? false,
      updatedAt: _parseDate(json['updated_at']),
      safeErrorCategory: _parseError(json['safe_error_category']),
    );
  }
}

class ApiConfiguration {
  const ApiConfiguration({
    required this.baseUrl,
    required this.clientVersion,
    this.schemaVersion = 1,
    this.enabled = true,
  });

  final String baseUrl;
  final String clientVersion;
  final int schemaVersion;
  final bool enabled;

  Map<String, dynamic> toJson() => {
    'base_url': baseUrl,
    'client_version': clientVersion,
    'schema_version': schemaVersion,
    'enabled': enabled,
  };
}

class SyncRunSnapshot {
  const SyncRunSnapshot({
    required this.receiveState,
    required this.sendState,
    required this.startedAt,
    this.finishedAt,
    this.lastSuccessfulSyncAt,
    this.pendingCount = 0,
    this.categoryCounts = const {},
    this.sourceCounts = const {},
    this.safeErrorCategory,
    this.automaticProcessing = true,
  });

  final SyncReceiveState receiveState;
  final SyncSendState sendState;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final DateTime? lastSuccessfulSyncAt;
  final int pendingCount;
  final Map<String, int> categoryCounts;
  final Map<String, int> sourceCounts;
  final SyncErrorCategory? safeErrorCategory;
  final bool automaticProcessing;

  SyncRunSnapshot copyWith({
    SyncReceiveState? receiveState,
    SyncSendState? sendState,
    DateTime? startedAt,
    DateTime? finishedAt,
    DateTime? lastSuccessfulSyncAt,
    int? pendingCount,
    Map<String, int>? categoryCounts,
    Map<String, int>? sourceCounts,
    SyncErrorCategory? safeErrorCategory,
    bool? automaticProcessing,
    bool clearFinishedAt = false,
    bool clearLastSuccessfulSyncAt = false,
    bool clearSafeError = false,
  }) {
    return SyncRunSnapshot(
      receiveState: receiveState ?? this.receiveState,
      sendState: sendState ?? this.sendState,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: clearFinishedAt ? null : finishedAt ?? this.finishedAt,
      lastSuccessfulSyncAt: clearLastSuccessfulSyncAt
          ? null
          : lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt,
      pendingCount: pendingCount ?? this.pendingCount,
      categoryCounts: categoryCounts ?? this.categoryCounts,
      sourceCounts: sourceCounts ?? this.sourceCounts,
      safeErrorCategory: clearSafeError
          ? null
          : safeErrorCategory ?? this.safeErrorCategory,
      automaticProcessing: automaticProcessing ?? this.automaticProcessing,
    );
  }

  Map<String, dynamic> toJson() => {
    'receive_state': receiveState.name,
    'send_state': sendState.name,
    'started_at': startedAt.toUtc().toIso8601String(),
    if (finishedAt != null)
      'finished_at': finishedAt!.toUtc().toIso8601String(),
    if (lastSuccessfulSyncAt != null)
      'last_successful_sync_at': lastSuccessfulSyncAt!
          .toUtc()
          .toIso8601String(),
    'pending_count': pendingCount,
    'category_counts': categoryCounts,
    'source_counts': sourceCounts,
    if (safeErrorCategory != null)
      'safe_error_category': safeErrorCategory!.name,
    'automatic_processing': automaticProcessing,
  };
}

Map<String, dynamic> _stringMap(dynamic value) {
  if (value is! Map) return const {};
  return value.map((key, item) => MapEntry('$key', item));
}

DateTime? _parseDate(dynamic value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

SyncErrorCategory? _parseError(dynamic value) {
  if (value is! String) return null;
  for (final category in SyncErrorCategory.values) {
    if (category.name == value) return category;
  }
  return null;
}
