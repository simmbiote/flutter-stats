import 'package:flutter/material.dart';

import '../domain/connection_controller.dart';

class ConnectionActions extends StatelessWidget {
  const ConnectionActions({
    super.key,
    required this.controller,
    required this.onRequest,
  });

  final ConnectionController controller;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: controller.busy ? null : controller.openSettings,
          icon: const Icon(Icons.settings_outlined),
          label: const Text('Open settings'),
        ),
        if (controller.snapshot?.state.name == 'connected')
          TextButton.icon(
            onPressed: controller.busy ? null : controller.disconnect,
            icon: const Icon(Icons.link_off),
            label: const Text('Disconnect'),
          ),
      ],
    );
  }
}
