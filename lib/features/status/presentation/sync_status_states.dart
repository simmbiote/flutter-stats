import 'package:flutter/material.dart';

class SyncStatusStateBanner extends StatelessWidget {
  const SyncStatusStateBanner({
    super.key,
    required this.state,
    required this.title,
  });

  final dynamic state;
  final String title;

  @override
  Widget build(BuildContext context) {
    final name = state == null ? 'waiting' : state.toString().split('.').last;
    final isProblem = const {
      'blocked',
      'failed',
      'retryScheduled',
    }.contains(name);
    final color = isProblem
        ? Theme.of(context).colorScheme.errorContainer
        : Theme.of(context).colorScheme.secondaryContainer;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('$title: ${_label(name)}'),
    );
  }

  String _label(String value) => switch (value) {
    'waiting' => 'Waiting for a run',
    'receiving' => 'Reading new records',
    'sending' => 'Sending records',
    'sent' => 'Acknowledged by the service',
    'empty' => 'No records waiting',
    'blocked' => 'Action is needed',
    'paused' => 'Android deferred the run',
    'failed' => 'The run needs attention',
    'complete' => 'Read completed',
    'retryScheduled' => 'A retry is scheduled',
    _ => 'Waiting',
  };
}
