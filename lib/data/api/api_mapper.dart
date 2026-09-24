import '../../features/sync/domain/models.dart';
import 'api_models.dart';

class ApiMapper {
  const ApiMapper();

  ApiRequestEnvelope map(
    PendingOperation operation, {
    String clientVersion = '1.0.0',
  }) {
    operation.validate();
    if (operation.operation == HealthRecordOperation.upsert) {
      final record = operation.payload!;
      return ApiRequestEnvelope(
        schemaVersion: '1',
        sourcePlatform: record.identity.sourcePlatform,
        operation: HealthRecordOperation.upsert,
        records: [record.toJson()],
      );
    }
    return ApiRequestEnvelope(
      schemaVersion: '1',
      sourcePlatform: operation.identity.sourcePlatform,
      operation: HealthRecordOperation.delete,
      records: [
        {
          'record_id': operation.identity.sourceRecordId,
          'source_platform': operation.identity.sourcePlatform,
          'record_type': operation.identity.recordType,
          'mutation_id': operation.operationId,
        },
      ],
    );
  }

  Map<String, dynamic> mapForDebugFixture(PendingOperation operation) {
    return map(operation).toJson();
  }
}
