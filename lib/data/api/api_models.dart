import '../../features/sync/domain/models.dart';

class ApiRequestEnvelope {
  const ApiRequestEnvelope({
    required this.schemaVersion,
    required this.sourcePlatform,
    required this.operation,
    required this.records,
  });

  final String schemaVersion;
  final String sourcePlatform;
  final HealthRecordOperation operation;
  final List<Map<String, dynamic>> records;

  Map<String, dynamic> toJson() => {
    'schema_version': schemaVersion,
    'source_platform': sourcePlatform,
    'operation': operation.name,
    'records': records,
  };
}

class ApiResponseEnvelope {
  const ApiResponseEnvelope({
    required this.accepted,
    this.acknowledgedRecordIds = const {},
    this.retryAfterSeconds,
    this.errorCode,
  });

  final bool accepted;
  final Set<String> acknowledgedRecordIds;
  final int? retryAfterSeconds;
  final String? errorCode;

  factory ApiResponseEnvelope.fromJson(Map<String, dynamic> json) {
    final rawIds =
        json['acknowledged_record_ids'] ?? json['record_ids'] ?? const [];
    final ids = rawIds is List
        ? rawIds.whereType<String>().toSet()
        : <String>{};
    final accepted = json['accepted'] as bool? ?? json['status'] == 'accepted';
    return ApiResponseEnvelope(
      accepted: accepted,
      acknowledgedRecordIds: ids,
      retryAfterSeconds: (json['retry_after_seconds'] as num?)?.toInt(),
      errorCode: json['error_code'] as String?,
    );
  }
}
