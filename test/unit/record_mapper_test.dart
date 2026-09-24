import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stats/data/health/record_mapper.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';

void main() {
  const mapper = RecordMapper();

  test('normalizes a record and preserves Samsung origin', () {
    final start = DateTime.utc(2026, 9, 24, 8);
    final record = mapper.fromFields(
      sourcePlatform: 'android_health_connect',
      sourceRecordId: 'record-1',
      recordType: 'steps',
      startTime: start,
      endTime: start.add(const Duration(minutes: 15)),
      value: 100,
      unit: 'count',
      sourceVersion: 'v1',
      sourceName: 'Samsung Health',
      sourceId: 'com.samsung.android.health',
    );

    expect(record.category, HealthCategory.activity);
    expect(record.origin, 'samsung_health');
    expect(record.sourceName, 'Samsung Health');
    expect(record.toJson()['measurement'], containsPair('value', 100));
  });

  test('rejects an invalid time range and preserves validation rules', () {
    final start = DateTime.utc(2026, 9, 24, 8);
    expect(
      () => mapper.fromFields(
        sourcePlatform: 'android_health_connect',
        sourceRecordId: 'record-1',
        recordType: 'steps',
        startTime: start,
        endTime: start.subtract(const Duration(minutes: 1)),
        value: 100,
        unit: 'count',
        sourceVersion: 'v1',
        sourceName: 'Fixture',
      ),
      throwsFormatException,
    );
  });

  test('round trips a health record without losing identity or unit', () {
    final record = mapper.fromFields(
      sourcePlatform: 'android_health_connect',
      sourceRecordId: 'record-2',
      recordType: 'weight',
      startTime: DateTime.utc(2026, 9, 23),
      endTime: DateTime.utc(2026, 9, 23),
      value: 72.4,
      unit: 'kilogram',
      sourceVersion: 'v2',
      sourceName: 'Fixture',
    );
    final decoded = HealthRecordSnapshot.fromJson(record.toJson());
    expect(decoded.identity, record.identity);
    expect(decoded.measurement.value, 72.4);
    expect(decoded.measurement.unit, 'kilogram');
  });
}
