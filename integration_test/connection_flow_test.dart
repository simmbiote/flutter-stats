import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_stats/app/app.dart';
import 'package:flutter_stats/app/dependencies.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('device flow explains and grants synthetic read access', (
    tester,
  ) async {
    final dependencies = AppDependencies.demo();
    addTearDown(dependencies.dispose);
    await tester.pumpWidget(FlutterStatsApp(dependencies: dependencies));
    await tester.tap(find.text('Review and grant access'));
    await tester.pumpAndSettle();
    expect(find.text('Allow read-only health access'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(
      dependencies.connectionController.snapshot?.state,
      ConnectionState.connected,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
