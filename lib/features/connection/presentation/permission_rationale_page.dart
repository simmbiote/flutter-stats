import 'package:flutter/material.dart';

import '../../../data/health/permission_catalog.dart';
import '../../sync/domain/models.dart';

class PermissionRationalePage extends StatelessWidget {
  const PermissionRationalePage({
    super.key,
    required this.onRequest,
    required this.onCancel,
  });

  final VoidCallback onRequest;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final catalog = const PermissionCatalog();
    final categories = <String, List<PermissionDescriptor>>{};
    for (final descriptor in catalog.all) {
      categories
          .putIfAbsent(descriptor.category.label, () => [])
          .add(descriptor);
    }
    return AlertDialog(
      title: const Text('Allow read-only health access'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Flutter Stats reads supported Health Connect records and sends them to your configured receiving service. It never writes to Health Connect.',
            ),
            const SizedBox(height: 16),
            for (final entry in categories.entries) ...[
              Text(entry.key, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              for (final descriptor in entry.value)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ${descriptor.label}: ${descriptor.description}',
                  ),
                ),
              const SizedBox(height: 10),
            ],
            const Text(
              'You can change access later in system settings. Local health payloads are removed after the receiving service acknowledges them.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: const Text('Not now')),
        FilledButton(onPressed: onRequest, child: const Text('Continue')),
      ],
    );
  }
}
