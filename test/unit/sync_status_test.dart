import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stats/features/status/domain/sync_status.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';

void main() {
  test('keeps receiving and sending states independent', () {
    final controller = SyncStatusController();
    final snapshot = SyncRunSnapshot(
      receiveState: SyncReceiveState.complete,
      sendState: SyncSendState.retryScheduled,
      startedAt: DateTime.utc(2026, 9, 24),
      pendingCount: 2,
      safeErrorCategory: SyncErrorCategory.temporarilyUnavailable,
    );
    controller.update(snapshot);
    expect(controller.snapshot.receiveState, SyncReceiveState.complete);
    expect(controller.snapshot.sendState, SyncSendState.retryScheduled);
    expect(controller.snapshot.pendingCount, 2);
  });

  test('status snapshots expose counts but no health values', () {
    final controller = SyncStatusController();
    controller.updateConnection(
      const ConnectionSnapshot(
        state: ConnectionState.connected,
        availability: HealthAvailability.available,
        permissions: {'steps': PermissionStatus.granted},
      ),
    );
    expect(controller.connection?.state, ConnectionState.connected);
    expect(controller.snapshot.toJson().keys, isNot(contains('measurement')));
  });
}
