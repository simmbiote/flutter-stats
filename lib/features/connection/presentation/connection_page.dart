import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../../../app/dependencies.dart';
import '../../../app/lifecycle/app_lifecycle_listener.dart';
import '../../../data/health/permission_catalog.dart';
import '../../status/presentation/sync_status_view.dart';
import '../../sync/domain/models.dart';
import '../domain/connection_controller.dart';
import 'api_credential_dialog.dart';
import 'connection_actions.dart';
import 'permission_rationale_page.dart';

class ConnectionPage extends ConsumerStatefulWidget {
  const ConnectionPage({super.key});

  @override
  ConsumerState<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends ConsumerState<ConnectionPage> {
  late final AppLifecycleObserver _lifecycleObserver;

  @override
  void initState() {
    super.initState();
    _lifecycleObserver = AppLifecycleObserver(
      ref.read(appDependenciesProvider),
    );
    _lifecycleObserver.attach();
  }

  @override
  void dispose() {
    _lifecycleObserver.detach();
    super.dispose();
  }

  Future<void> _showRationale(ConnectionController controller) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => PermissionRationalePage(
        onCancel: () => Navigator.of(dialogContext).pop(),
        onRequest: () async {
          Navigator.of(dialogContext).pop();
          await controller.requestPermissions();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dependencies = ref.watch(appDependenciesProvider);
    final controller = dependencies.connectionController;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => _buildPage(context, dependencies, controller),
    );
  }

  Widget _buildPage(
    BuildContext context,
    AppDependencies dependencies,
    ConnectionController controller,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Connect'),
        actions: [
          IconButton(
            tooltip: 'Configure receiving service',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => ApiCredentialDialog(
                credentialProvider: dependencies.credentialProvider,
              ),
            ),
            icon: const Icon(Icons.key_outlined),
          ),
          IconButton(
            tooltip: 'Refresh connection',
            onPressed: controller.busy ? null : controller.refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Text(
              'Private, read-only sync',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose what Flutter Stats may read. New records are processed automatically when Android allows background work.',
            ),
            if (dependencies.config.isDevelopmentMode) ...[
              const SizedBox(height: 12),
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Development mode: synthetic source/API data is enabled. Do not use it for production health data.',
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            _ConnectionSummary(controller: controller),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: controller.busy
                  ? null
                  : () => _showRationale(controller),
              icon: const Icon(Icons.health_and_safety_outlined),
              label: Text(
                controller.snapshot?.canRead == true
                    ? 'Review read permissions'
                    : 'Review and grant access',
              ),
            ),
            const SizedBox(height: 16),
            ConnectionActions(
              controller: controller,
              onRequest: () => _showRationale(controller),
            ),
            if (controller.safeMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                controller.safeMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 28),
            Text('Sync status', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            SyncStatusView(
              controller: dependencies.statusController,
              onRetry: () => dependencies.runSync(trigger: 'status_retry'),
            ),
            const SizedBox(height: 20),
            const _PrivacyNote(),
          ],
        ),
      ),
    );
  }
}

class _ConnectionSummary extends StatelessWidget {
  const _ConnectionSummary({required this.controller});

  final ConnectionController controller;

  @override
  Widget build(BuildContext context) {
    final snapshot = controller.snapshot;
    final catalog = const PermissionCatalog();
    final permissions = snapshot?.permissions ?? const {};
    final granted = permissions.values
        .where((value) => value == PermissionStatus.granted)
        .length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  snapshot?.state == ConnectionState.connected
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
                  color: snapshot?.state == ConnectionState.connected
                      ? Colors.green.shade700
                      : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _stateLabel(snapshot?.state),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '$granted of ${catalog.recordTypes.length} supported read categories granted',
            ),
            const SizedBox(height: 6),
            Text(
              snapshot?.backgroundReadAuthorized == true
                  ? 'Background reading is authorized; Android may still defer work.'
                  : 'Background reading is not authorized yet.',
            ),
          ],
        ),
      ),
    );
  }

  String _stateLabel(ConnectionState? state) {
    return switch (state) {
      ConnectionState.connected => 'Health access connected',
      ConnectionState.partiallyAllowed => 'Some access is connected',
      ConnectionState.denied => 'Health access is not granted',
      ConnectionState.revoked => 'Health access was revoked',
      ConnectionState.notInstalled => 'Health Connect is not installed',
      ConnectionState.updateRequired => 'Health Connect needs an update',
      ConnectionState.restricted => 'Health access is restricted',
      ConnectionState.unavailable => 'Health Connect is unavailable',
      ConnectionState.disconnected => 'Health access is disconnected',
      _ => 'Checking health access…',
    };
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'This app does not write to Health Connect. Values are not shown in sync status or diagnostic logs. Unsent payloads remain encrypted until delivery is acknowledged or you disconnect.',
        ),
      ),
    );
  }
}
