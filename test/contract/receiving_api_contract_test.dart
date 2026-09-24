import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stats/core/errors/sync_error.dart';
import 'package:flutter_stats/data/api/api_mapper.dart';
import 'package:flutter_stats/data/api/receiving_api.dart';
import 'package:flutter_stats/data/credentials/installation_credential_store.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';

void main() {
  const mapper = ApiMapper();
  final identity = HealthRecordIdentity(
    sourcePlatform: 'android_health_connect',
    sourceRecordId: 'contract-record',
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

  test('maps an upsert to schema version 1', () {
    final operation = PendingOperation(
      operationId: 'op-1',
      identity: identity,
      operation: HealthRecordOperation.upsert,
      state: PendingOperationState.pending,
      createdAt: now,
      payload: record,
    );
    final envelope = mapper.map(operation).toJson();
    expect(envelope['schema_version'], '1');
    expect(envelope['operation'], 'upsert');
    expect(
      (envelope['records'] as List).single,
      containsPair('record_id', 'contract-record'),
    );
  });

  test('maps a delete without measurement values', () {
    final operation = PendingOperation(
      operationId: 'op-2',
      identity: identity,
      operation: HealthRecordOperation.delete,
      state: PendingOperationState.pending,
      createdAt: now,
    );
    final envelope = mapper.map(operation).toJson();
    final recordJson = (envelope['records'] as List).single as Map;
    expect(envelope['operation'], 'delete');
    expect(recordJson.containsKey('measurement'), isFalse);
    expect(recordJson['mutation_id'], 'op-2');
  });

  test(
    'sends authenticated idempotent POST and accepts acknowledgement',
    () async {
      final adapter = _RecordingAdapter();
      final client = Dio()..httpClientAdapter = adapter;
      final api = DioReceivingApi(
        configuration: const ApiConfiguration(
          baseUrl: 'https://example.test',
          clientVersion: '1.2.3',
        ),
        credentialProvider: InMemoryCredentialProvider('fixture-credential'),
        client: client,
      );
      final operation = PendingOperation(
        operationId: 'op-http',
        identity: identity,
        operation: HealthRecordOperation.upsert,
        state: PendingOperationState.pending,
        createdAt: now,
        payload: record,
      );
      final acknowledgement = await api.submit(operation);
      expect(acknowledgement.accepted, isTrue);
      expect(adapter.request?.method, 'POST');
      expect(adapter.request?.uri.path, '/v1/health-records');
      expect(
        adapter.request?.headers['Authorization'],
        'Bearer fixture-credential',
      );
      expect(adapter.request?.headers['Idempotency-Key'], 'op-http');
      expect(adapter.request?.headers['X-Schema-Version'], '1');
      expect((adapter.body as Map)['operation'], 'upsert');
    },
  );

  test(
    'does not call the network without an installation credential',
    () async {
      final api = DioReceivingApi(
        configuration: const ApiConfiguration(
          baseUrl: 'https://example.invalid',
          clientVersion: 'test',
        ),
        credentialProvider: InMemoryCredentialProvider(),
        client: Dio(),
      );
      final operation = PendingOperation(
        operationId: 'op-3',
        identity: identity,
        operation: HealthRecordOperation.delete,
        state: PendingOperationState.pending,
        createdAt: now,
      );
      expect(
        () => api.submit(operation),
        throwsA(
          isA<SyncException>().having(
            (error) => error.category,
            'category',
            SyncErrorCategory.missingCredential,
          ),
        ),
      );
    },
  );
}

class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? request;
  Object? body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    body = options.data;
    return ResponseBody.fromString(
      jsonEncode({'accepted': true}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
