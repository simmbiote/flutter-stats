import 'package:flutter/material.dart';

import '../../sync/domain/models.dart';
import '../domain/sync_status.dart';
import 'sync_status_states.dart';

class SyncStatusView extends StatelessWidget {
  const SyncStatusView({
    super.key,
    required this.controller,
    required this.onRetry,
  });

  final SyncStatusController controller;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final snapshot = controller.snapshot;
        final pending = snapshot.pendingCount;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _StateCard(
                    title: 'Receiving',
                    state: snapshot.receiveState,
                    icon: Icons.download_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StateCard(
                    title: 'Sending',
                    state: snapshot.sendState,
                    icon: Icons.upload_outlined,
                  ),
                ),
              ],
            ),
            if (snapshot.receiveState == SyncReceiveState.paused ||
                snapshot.sendState == SyncSendState.retryScheduled) ...[
              const SizedBox(height: 12),
              SyncStatusStateBanner(
                state: snapshot.receiveState == SyncReceiveState.paused
                    ? snapshot.receiveState
                    : snapshot.sendState,
                title: snapshot.receiveState == SyncReceiveState.paused
                    ? 'Receiving'
                    : 'Sending',
              ),
            ],
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pending == 1
                          ? '1 record waiting to send'
                          : '$pending records waiting to send',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(_lastSuccessLabel(snapshot.lastSuccessfulSyncAt)),
                    if (snapshot.safeErrorCategory != null &&
                        snapshot.safeErrorCategory !=
                            SyncErrorCategory.unknown) ...[
                      const SizedBox(height: 8),
                      Text(
                        _errorLabel(snapshot.safeErrorCategory!),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    if (snapshot.sendState == SyncSendState.retryScheduled ||
                        snapshot.sendState == SyncSendState.failed) ...[
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: controller.busy ? null : onRetry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry sending'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (controller.busy) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(
                semanticsLabel: 'Synchronization in progress',
              ),
            ],
          ],
        );
      },
    );
  }

  String _lastSuccessLabel(DateTime? timestamp) {
    if (timestamp == null) return 'No successful delivery yet';
    final local = timestamp.toLocal();
    return 'Last successful delivery: ${_formatTime(local)}';
  }

  String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _errorLabel(SyncErrorCategory category) {
    return switch (category) {
      SyncErrorCategory.missingCredential =>
        'A deployment credential is needed before sending.',
      SyncErrorCategory.authorization =>
        'The receiving service rejected authorization.',
      SyncErrorCategory.permissionDenied =>
        'Health read permission is required.',
      SyncErrorCategory.permissionRevoked =>
        'Health read permission was revoked.',
      SyncErrorCategory.rateLimited =>
        'The service asked us to wait before retrying.',
      SyncErrorCategory.timeout => 'The last delivery attempt timed out.',
      SyncErrorCategory.connection =>
        'The receiving service is currently unreachable.',
      SyncErrorCategory.unavailable =>
        'Health Connect is unavailable on this device.',
      SyncErrorCategory.validation =>
        'The service could not validate the pending operation.',
      _ => 'Synchronization needs attention.',
    };
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({
    required this.title,
    required this.state,
    required this.icon,
  });

  final String title;
  final dynamic state;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final label = _label(state);
    return Semantics(
      container: true,
      label: '$title status: $label',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }

  String _label(dynamic value) {
    final name = value == null ? 'waiting' : value.toString().split('.').last;
    return switch (name) {
      'waiting' => 'Waiting',
      'receiving' => 'Receiving',
      'sending' => 'Sending',
      'sent' => 'Sent',
      'empty' => 'No new data',
      'blocked' => 'Blocked',
      'paused' => 'Deferred',
      'failed' => 'Needs attention',
      'complete' => 'Up to date',
      'retryScheduled' => 'Retry scheduled',
      _ => 'Waiting',
    };
  }
}
