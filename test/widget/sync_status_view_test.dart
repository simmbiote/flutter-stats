import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stats/features/status/domain/sync_status.dart';
import 'package:flutter_stats/features/status/presentation/sync_status_view.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';

void main() {
  testWidgets('renders independent status labels and recovery action', (
    tester,
  ) async {
    final controller = SyncStatusController();
    controller.update(
      SyncRunSnapshot(
        receiveState: SyncReceiveState.complete,
        sendState: SyncSendState.retryScheduled,
        startedAt: DateTime.utc(2026, 9, 24),
        pendingCount: 1,
        safeErrorCategory: SyncErrorCategory.temporarilyUnavailable,
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
    expect(find.text('Retry scheduled'), findsOneWidget);
    expect(find.text('1 record waiting to send'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Receiving status: Up to date'),
      findsOneWidget,
    );
  });
}
