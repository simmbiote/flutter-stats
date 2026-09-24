import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stats/data/health/fake_health_data_source.dart';
import 'package:flutter_stats/data/persistence/in_memory_pending_store.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';
import 'package:flutter_stats/features/sync/domain/sync_coordinator.dart';

import '../support/fake_receiving_api.dart';
import '../support/test_harness.dart';

void main() {
  final now = DateTime.utc(2026, 9, 24, 12);
  final record = HealthRecordSnapshot(
    identity: const HealthRecordIdentity(
      sourcePlatform: 'android_health_connect',
      sourceRecordId: 'record-1',
      recordType: 'steps',
    ),
    category: HealthCategory.activity,
    startTime: now.subtract(const Duration(hours: 1)),
    endTime: now,
    measurement: const HealthMeasurement(
      kind: 'numeric',
      value: 100,
      unit: 'count',
    ),
    sourceVersion: 'v1',
    sourceName: 'Fixture',
  );

  test('automatically queues and acknowledges an initial window', () async {
    final source = FakeHealthDataSource(granted: true, records: [record]);
    final store = InMemoryPendingStore();
    final api = FakeReceivingApi();
    final coordinator = SyncCoordinator(
      source: source,
      store: store,
      api: api,
      clock: FixedClock(now),
      ids: SequentialIdGenerator(),
    );

    final result = await coordinator.run(trigger: 'test');
    expect(result.receiveState, SyncReceiveState.complete);
    expect(result.sendState, SyncSendState.sent);
    expect(await store.countPending(), 0);
    expect(api.submitted, hasLength(1));
    expect(source.readCount, 1);
  });

  test(
    'processes an upsert and delete as separate stable operations',
    () async {
      final updated = HealthRecordSnapshot(
        identity: record.identity,
        category: record.category,
        startTime: record.startTime,
        endTime: record.endTime,
        measurement: const HealthMeasurement(
          kind: 'numeric',
          value: 200,
          unit: 'count',
        ),
        sourceVersion: 'v2',
        sourceName: 'Fixture',
      );
      final changes = [
        SourceChange(
          identity: updated.identity,
          operation: HealthRecordOperation.upsert,
          record: updated,
        ),
        const SourceChange(
          identity: HealthRecordIdentity(
            sourcePlatform: 'android_health_connect',
            sourceRecordId: 'record-to-delete',
            recordType: 'steps',
          ),
          operation: HealthRecordOperation.delete,
        ),
      ];
      final source = FakeHealthDataSource(
        granted: true,
        records: [record],
        changes: changes,
      );
      final store = InMemoryPendingStore();
      final api = FakeReceivingApi();
      final coordinator = SyncCoordinator(
        source: source,
        store: store,
        api: api,
        clock: FixedClock(now),
        ids: SequentialIdGenerator(),
      );

      await coordinator.run();
      final result = await coordinator.run();
      expect(result.receiveState, SyncReceiveState.complete);
      expect(
        api.submitted.map((operation) => operation.operation),
        contains(HealthRecordOperation.upsert),
      );
      expect(
        api.submitted.map((operation) => operation.operation),
        contains(HealthRecordOperation.delete),
      );
      expect(await store.countPending(), 0);
    },
  );

  test(
    'keeps a failed operation pending and retries it without a new ID',
    () async {
      final source = FakeHealthDataSource(granted: true, records: [record]);
      final store = InMemoryPendingStore();
      final api = FakeReceivingApi(
        failuresRemaining: 1,
        failure: SyncErrorCategory.server,
      );
      final coordinator = SyncCoordinator(
        source: source,
        store: store,
        api: api,
        clock: FixedClock(now),
        ids: SequentialIdGenerator(),
      );

      final first = await coordinator.run();
      expect(first.sendState, SyncSendState.retryScheduled);
      expect(await store.countPending(), 1);
      final operationId = api.submitted.single.operationId;

      final second = await coordinator.run();
      expect(second.sendState, SyncSendState.sent);
      expect(api.submitted.last.operationId, operationId);
      expect(await store.countPending(), 0);
    },
  );

  test('accounts for a 1,000-record mixed validation set', () async {
    final records = List<HealthRecordSnapshot>.generate(1000, (index) {
      return HealthRecordSnapshot(
        identity: HealthRecordIdentity(
          sourcePlatform: 'android_health_connect',
          sourceRecordId: 'bulk-$index',
          recordType: index.isEven ? 'steps' : 'weight',
        ),
        category: index.isEven
            ? HealthCategory.activity
            : HealthCategory.bodyMeasurements,
        startTime: now,
        endTime: now.add(const Duration(minutes: 1)),
        measurement: HealthMeasurement(
          kind: 'numeric',
          value: index,
          unit: index.isEven ? 'count' : 'kilogram',
        ),
        sourceVersion: 'v1',
        sourceName: 'Fixture',
      );
    });
    final source = FakeHealthDataSource(granted: true, records: records);
    final store = InMemoryPendingStore();
    final api = FakeReceivingApi();
    final coordinator = SyncCoordinator(
      source: source,
      store: store,
      api: api,
      clock: FixedClock(now),
      ids: SequentialIdGenerator(),
    );

    final result = await coordinator.run();
    expect(result.receiveState, SyncReceiveState.complete);
    expect(api.submitted, hasLength(1000));
    expect(await store.countPending(), 0);
  });

  test('syncs only categories granted by a partial permission set', () async {
    final source = _PartialPermissionSource(records: [record]);
    final store = InMemoryPendingStore();
    final api = FakeReceivingApi();
    final coordinator = SyncCoordinator(
      source: source,
      store: store,
      api: api,
      clock: FixedClock(now),
      ids: SequentialIdGenerator(),
    );

    final result = await coordinator.run(trigger: 'partial-test');

    expect(result.receiveState, SyncReceiveState.complete);
    expect(source.lastInitialRecordTypes, ['steps']);
    expect(api.submitted, hasLength(1));
  });

  test('does not read while permissions are denied', () async {
    final source = FakeHealthDataSource(granted: false, records: [record]);
    final store = InMemoryPendingStore();
    final api = FakeReceivingApi();
    final coordinator = SyncCoordinator(
      source: source,
      store: store,
      api: api,
      clock: FixedClock(now),
      ids: SequentialIdGenerator(),
    );
    final result = await coordinator.run();
    expect(result.receiveState, SyncReceiveState.blocked);
    expect(result.sendState, SyncSendState.blocked);
    expect(source.readCount, 0);
    expect(api.submitted, isEmpty);
  });
}

class _PartialPermissionSource extends FakeHealthDataSource {
  _PartialPermissionSource({required List<HealthRecordSnapshot> records})
    : super(granted: true, records: records);

  @override
  Future<ConnectionSnapshot> getPermissionSnapshot({
    List<String>? recordTypes,
  }) async {
    return const ConnectionSnapshot(
      state: ConnectionState.partiallyAllowed,
      availability: HealthAvailability.available,
      permissions: {'steps': PermissionStatus.granted},
    );
  }
}
