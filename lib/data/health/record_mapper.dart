import '../../features/sync/domain/models.dart';
import 'permission_catalog.dart';
import 'source_origin_mapper.dart';

class RecordMapper {
  const RecordMapper({
    this.catalog = const PermissionCatalog(),
    this.originMapper = const SourceOriginMapper(),
  });

  final PermissionCatalog catalog;
  final SourceOriginMapper originMapper;

  HealthRecordSnapshot fromFields({
    required String sourcePlatform,
    required String sourceRecordId,
    required String recordType,
    required DateTime startTime,
    required DateTime endTime,
    required num? value,
    required String unit,
    required String sourceVersion,
    required String sourceName,
    String? sourceId,
  }) {
    final record = HealthRecordSnapshot(
      identity: HealthRecordIdentity(
        sourcePlatform: sourcePlatform,
        sourceRecordId: sourceRecordId,
        recordType: recordType,
      ),
      category: catalog.categoryFor(recordType),
      startTime: startTime.toUtc(),
      endTime: endTime.toUtc(),
      measurement: HealthMeasurement(
        kind: value == null ? 'session' : 'numeric',
        value: value,
        unit: unit,
      ),
      sourceVersion: sourceVersion,
      sourceName: originMapper.displaySource(
        sourceName: sourceName,
        sourceId: sourceId,
      ),
      origin: originMapper.originFor(
        sourceName: sourceName,
        sourceId: sourceId,
      ),
    );
    record.validate();
    return record;
  }
}
