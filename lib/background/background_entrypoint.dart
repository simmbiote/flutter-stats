import 'package:flutter/widgets.dart' hide ConnectionState;
import 'package:workmanager/workmanager.dart';

import '../app/dependencies.dart';
import '../features/sync/domain/models.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((_, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    AppDependencies? dependencies;
    try {
      dependencies = await AppDependencies.create();
      await dependencies.connectionController.refresh();
      if (dependencies.connectionController.snapshot?.state ==
          ConnectionState.connected) {
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
