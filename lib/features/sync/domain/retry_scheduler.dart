import '../../../core/errors/sync_error.dart';
import '../../sync/domain/models.dart';

class RetryDecision {
  const RetryDecision({required this.shouldRetry, required this.nextAttemptAt});

  final bool shouldRetry;
  final DateTime? nextAttemptAt;
}

class RetryScheduler {
  const RetryScheduler({this.policy = const RetryPolicy()});

  final RetryPolicy policy;

  RetryDecision decide({
    required SyncErrorCategory category,
    required int attempt,
    required DateTime now,
  }) {
    if (!policy.isRetryable(category) || attempt >= policy.maxAttempts) {
      return const RetryDecision(shouldRetry: false, nextAttemptAt: null);
    }
    return RetryDecision(
      shouldRetry: true,
      nextAttemptAt: now.add(policy.delayForAttempt(attempt)),
    );
  }
}
