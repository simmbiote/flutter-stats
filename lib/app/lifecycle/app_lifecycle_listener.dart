import 'package:flutter/widgets.dart' hide ConnectionState;

import '../dependencies.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  AppLifecycleObserver(this.dependencies);

  final AppDependencies dependencies;

  void attach() {
    WidgetsBinding.instance.addObserver(this);
  }

  void detach() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) return;
    await dependencies.connectionController.refresh();
    if (dependencies.connectionController.snapshot?.canRead == true) {
      await dependencies.runSync(trigger: 'resume');
    }
  }
}
