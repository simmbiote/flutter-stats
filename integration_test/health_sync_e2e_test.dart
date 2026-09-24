import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_stats/app/app.dart';
import 'package:flutter_stats/app/dependencies.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('synthetic end-to-end flow reaches acknowledged status', (
    tester,
  ) async {
    final dependencies = AppDependencies.demo();
    addTearDown(dependencies.dispose);
    await dependencies.connectionController.requestPermissions();
    await dependencies.runSync(trigger: 'integration_test');
    await tester.pumpWidget(FlutterStatsApp(dependencies: dependencies));
    expect(find.text('Receiving'), findsOneWidget);
    expect(find.text('Sending'), findsOneWidget);
    expect(
      dependencies.statusController.snapshot.sendState,
      SyncSendState.sent,
    );
    expect(dependencies.statusController.snapshot.pendingCount, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
