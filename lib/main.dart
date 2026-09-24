import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import 'app/app.dart';
import 'app/dependencies.dart';
import 'background/background_entrypoint.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await AppDependencies.create();
  try {
    await Workmanager().initialize(callbackDispatcher);
  } catch (_) {
    // The UI remains usable if a platform does not support background tasks.
  }
  await dependencies.initialize();
  runApp(FlutterStatsApp(dependencies: dependencies));
}
