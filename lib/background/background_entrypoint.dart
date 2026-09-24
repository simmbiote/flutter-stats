import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import '../app/dependencies.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((_, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    AppDependencies? dependencies;
    try {
      dependencies = await AppDependencies.create();
      await dependencies.connectionController.refresh();
      if (dependencies.connectionController.snapshot?.canRead == true) {
        await dependencies.runSync(
          trigger: inputData?['trigger'] == 'periodic'
              ? 'background_periodic'
              : 'background_immediate',
        );
      }
      return true;
    } catch (_) {
      return false;
    } finally {
      await dependencies?.dispose();
    }
  });
}
