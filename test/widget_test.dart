import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stats/app/app.dart';
import 'package:flutter_stats/app/dependencies.dart';

void main() {
  testWidgets('renders the read-only connection experience', (tester) async {
    final dependencies = AppDependencies.demo();
    addTearDown(dependencies.dispose);
    await tester.pumpWidget(FlutterStatsApp(dependencies: dependencies));
    expect(find.text('Health Connect'), findsOneWidget);
    expect(find.text('Private, read-only sync'), findsOneWidget);
    expect(find.text('Receiving'), findsOneWidget);
    expect(find.text('Sending'), findsOneWidget);
  });
}
