import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_stats/app/dependencies.dart';
import 'package:flutter_stats/core/config/app_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('reports a safe Health Connect availability state', (
    tester,
  ) async {
    final dependencies = await AppDependencies.create(
      config: const AppConfig(apiBaseUrl: '', clientVersion: 'integration'),
    );
    addTearDown(dependencies.dispose);
    final availability = await dependencies.source.checkAvailability();
    expect(availability.name, isNotEmpty);
    expect(availability.name, isNot(contains('record')));
  });
}
