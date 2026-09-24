import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stats/core/errors/sync_error.dart';
import 'package:flutter_stats/data/api/receiving_api.dart';
import 'package:flutter_stats/data/credentials/installation_credential_store.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';
import '../../tool/mock_health_api.dart';

void main() {
  test('mock API accepts and idempotently acknowledges an operation', () async {
    final server = MockHealthApiServer();
    await server.start(port: 0);
    addTearDown(server.stop);

    final api = DioReceivingApi(
      configuration: ApiConfiguration(
        baseUrl: server.uri.toString().replaceFirst(RegExp(r'/$'), ''),
        clientVersion: 'test',
      ),
      credentialProvider: InMemoryCredentialProvider('dev-credential'),
      client: Dio(),
    );
    final identity = HealthRecordIdentity(
      sourcePlatform: 'android_health_connect',
      sourceRecordId: 'mock-record',
      recordType: 'steps',
    );
    final now = DateTime.utc(2026, 9, 24);
    final record = HealthRecordSnapshot(
      identity: identity,
      category: HealthCategory.activity,
      startTime: now,
      endTime: now.add(const Duration(minutes: 5)),
      measurement: const HealthMeasurement(
        kind: 'numeric',
        value: 10,
        unit: 'count',
      ),
      sourceVersion: 'v1',
      sourceName: 'Fixture',
    );
    final operation = PendingOperation(
      operationId: 'mock-op',
      identity: identity,
      operation: HealthRecordOperation.upsert,
      state: PendingOperationState.pending,
      createdAt: now,
      payload: record,
    );

    final first = await api.submit(operation);
    final second = await api.submit(operation);
    expect(first.accepted, isTrue);
    expect(second.accepted, isTrue);
    expect(server.requestCount, 2);
  });

  test(
    'mock API classifies an invalid credential as authorization failure',
    () async {
      final server = MockHealthApiServer();
      await server.start(port: 0);
      addTearDown(server.stop);
      final api = DioReceivingApi(
        configuration: ApiConfiguration(
          baseUrl: server.uri.toString().replaceFirst(RegExp(r'/$'), ''),
          clientVersion: 'test',
        ),
        credentialProvider: InMemoryCredentialProvider('wrong'),
        client: Dio(),
      );
      final operation = PendingOperation(
        operationId: 'mock-unauthorized',
        identity: const HealthRecordIdentity(
          sourcePlatform: 'android_health_connect',
          sourceRecordId: 'record',
          recordType: 'steps',
        ),
        operation: HealthRecordOperation.delete,
        state: PendingOperationState.pending,
        createdAt: DateTime.utc(2026, 9, 24),
      );
      expect(
        () => api.submit(operation),
        throwsA(
          isA<SyncException>().having(
            (error) => error.category,
            'category',
            SyncErrorCategory.authorization,
          ),
        ),
      );
    },
  );
}
