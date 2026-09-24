import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stats/app/dependencies.dart';
import 'package:flutter_stats/core/config/app_config.dart';
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

  test('real Health Connect data refuses an insecure API endpoint', () async {
    const config = AppConfig(
      apiBaseUrl: 'http://127.0.0.1:8787',
      clientVersion: 'test',
    );

    await expectLater(
      AppDependencies.create(config: config),
      throwsA(isA<StateError>()),
    );
  });

  test('the fake API cannot be paired with the real source', () async {
    const config = AppConfig(
      apiBaseUrl: 'https://staging.invalid',
      clientVersion: 'test',
      useFakeApi: true,
    );

    await expectLater(
      AppDependencies.create(config: config),
      throwsA(isA<StateError>()),
    );
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
