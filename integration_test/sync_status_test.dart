import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_stats/features/status/domain/sync_status.dart';
import 'package:flutter_stats/features/status/presentation/sync_status_view.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('device status view shows receiving and sending independently', (
    tester,
  ) async {
    final controller = SyncStatusController();
    controller.update(
      SyncRunSnapshot(
        receiveState: SyncReceiveState.complete,
        sendState: SyncSendState.blocked,
        startedAt: DateTime.now().toUtc(),
        pendingCount: 1,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SyncStatusView(controller: controller, onRetry: () async {}),
        ),
      ),
    );
    expect(find.text('Receiving'), findsOneWidget);
    expect(find.text('Sending'), findsOneWidget);
    expect(find.text('Up to date'), findsOneWidget);
    expect(find.text('Blocked'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
