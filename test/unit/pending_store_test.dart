import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stats/data/persistence/encrypted_payload_codec.dart';
import 'package:flutter_stats/data/persistence/in_memory_pending_store.dart';
import 'package:flutter_stats/data/persistence/secure_key_store.dart';
import 'package:flutter_stats/data/persistence/sync_repository.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';

import '../support/test_database.dart';

void main() {
  final now = DateTime.utc(2026, 9, 24, 12);
  final identity = HealthRecordIdentity(
    sourcePlatform: 'android_health_connect',
    sourceRecordId: 'private-record',
    recordType: 'heart_rate',
  );
  final record = HealthRecordSnapshot(
    identity: identity,
    category: HealthCategory.vitals,
    startTime: now,
    endTime: now.add(const Duration(minutes: 1)),
    measurement: const HealthMeasurement(
      kind: 'numeric',
      value: 70,
      unit: 'beats/minute',
    ),
    sourceVersion: 'v1',
    sourceName: 'Fixture',
  );
  final operation = PendingOperation(
    operationId: 'op-1',
    identity: identity,
    operation: HealthRecordOperation.upsert,
    state: PendingOperationState.pending,
    createdAt: now,
    payload: record,
  );

  test('validates that deletes do not carry a payload', () {
    final invalid = PendingOperation(
      operationId: 'op-delete',
      identity: identity,
      operation: HealthRecordOperation.delete,
      state: PendingOperationState.pending,
      createdAt: now,
      payload: record,
    );
    expect(invalid.validate, throwsFormatException);
  });

  test(
    'stores sensitive payloads encrypted and removes acknowledged data',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      final store = DriftPendingStore(
        database: database,
        codec: EncryptedPayloadCodec(keyStore: InMemoryKeyStore()),
      );
      await store.enqueue(operation);
      final raw = await database.select(database.pendingOperations).getSingle();
      expect(raw.encryptedPayload, isNotNull);
      expect(raw.encryptedPayload, isNot(contains('"value":70')));
      final loaded = await store.pendingOperations();
      expect(loaded.single.payload?.measurement.value, 70);
      await store.remove(operation.operationId);
      expect(await store.countPending(), 0);
    },
  );

  test('cursors and connection state survive a store round trip', () async {
    final database = createTestDatabase();
    addTearDown(database.close);
    final store = DriftPendingStore(
      database: database,
      codec: EncryptedPayloadCodec(keyStore: InMemoryKeyStore()),
    );
    await store.saveCursors({'steps': 'cursor-1'});
    final rawCursor = await database.select(database.syncCursors).getSingle();
    expect(rawCursor.token, isNot(contains('cursor-1')));
    final connection = ConnectionSnapshot(
      state: ConnectionState.connected,
      availability: HealthAvailability.available,
      permissions: {'steps': PermissionStatus.granted},
    );
    await store.saveConnection(connection);
    expect((await store.readCursors())['steps'], 'cursor-1');
    expect((await store.latestConnection())?.state, ConnectionState.connected);
  });

  test('in-memory store removes all pending data on disconnect', () async {
    final store = InMemoryPendingStore(
      initial: {operation.operationId: operation},
    );
    expect(await store.countPending(), 1);
    await store.clear();
    expect(await store.countPending(), 0);
  });
}
