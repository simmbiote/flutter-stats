import 'package:flutter/material.dart';

import '../../data/health/health_data_source.dart';

class SettingsLauncher {
  const SettingsLauncher(this.source);

  final HealthDataSource source;

  Future<void> open(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await source.openPermissionSettings();
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Open your device settings to manage health access.'),
        ),
      );
    }
  }
}
