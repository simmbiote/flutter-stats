import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stats/app/app.dart';
import 'package:flutter_stats/app/dependencies.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';

void main() {
  testWidgets('explains permissions before requesting read access', (
    tester,
  ) async {
    final dependencies = AppDependencies.demo();
    addTearDown(dependencies.dispose);
    await dependencies.connectionController.refresh();
    await tester.pumpWidget(FlutterStatsApp(dependencies: dependencies));

    expect(find.text('Health access is not granted'), findsOneWidget);
    await tester.tap(find.text('Review and grant access'));
    await tester.pumpAndSettle();
    expect(find.text('Allow read-only health access'), findsOneWidget);
    expect(
      find.textContaining('never writes to Health Connect'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(
      dependencies.connectionController.snapshot?.state,
      ConnectionState.connected,
    );
    expect(find.text('Health access connected'), findsOneWidget);
  });

  testWidgets('stores a credential without displaying it in status', (
    tester,
  ) async {
    final dependencies = AppDependencies.demo();
    addTearDown(dependencies.dispose);
    await tester.pumpWidget(FlutterStatsApp(dependencies: dependencies));
    await tester.tap(find.byTooltip('Configure receiving service'));
    await tester.pumpAndSettle();
    expect(find.text('Receiving service credential'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'fixture-only');
    await tester.tap(find.text('Save securely'));
    await tester.pumpAndSettle();
    expect(
      await dependencies.credentialProvider.readCredential(),
      'fixture-only',
    );
    expect(find.text('fixture-only'), findsNothing);
  });

  testWidgets('shows denied state without exposing a sync action as success', (
    tester,
  ) async {
    final dependencies = AppDependencies.demo();
    addTearDown(dependencies.dispose);
    await dependencies.connectionController.refresh();
    await tester.pumpWidget(FlutterStatsApp(dependencies: dependencies));
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Receiving'), findsOneWidget);
    expect(find.text('Waiting'), findsWidgets);
    expect(find.text('Sent'), findsNothing);
  });
}
