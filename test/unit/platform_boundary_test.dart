import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stats/data/health/fake_health_data_source.dart';
import 'package:flutter_stats/data/health/health_data_source.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';

void main() {
  test('domain can be exercised without a platform plugin', () async {
    final HealthDataSource source = FakeHealthDataSource(granted: true);
    final result = await source.readInitialWindow(
      start: DateTime.utc(2026, 9, 1),
      end: DateTime.utc(2026, 9, 30),
      recordTypes: const ['steps'],
    );
    expect(result.records, isNotEmpty);
    expect(source, isA<HealthDataSource>());
  });

  test('a future source adapter can use the same identity contract', () {
    const identity = HealthRecordIdentity(
      sourcePlatform: 'ios_healthkit',
      sourceRecordId: 'future-record',
      recordType: 'steps',
    );
    expect(identity.sourcePlatform, 'ios_healthkit');
    expect(identity.key, 'ios_healthkit|future-record|steps');
  });
}
