import '../../features/sync/domain/models.dart';

class SyncException implements Exception {
  const SyncException(
    this.category, {
    this.message,
    this.statusCode,
    this.retryable = false,
  });

  final SyncErrorCategory category;
  final String? message;
  final int? statusCode;
  final bool retryable;

  @override
  String toString() {
    final suffix = [
      ?message,
      if (statusCode case final code?) 'status=$code',
    ].join('; ');
    return 'SyncException(${category.name}${suffix.isEmpty ? '' : ': $suffix'})';
  }
}

class RetryPolicy {
  const RetryPolicy({
    this.maxAttempts = 6,
    this.initialDelay = const Duration(seconds: 30),
    this.maxDelay = const Duration(hours: 6),
  });

  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;

  bool isRetryable(SyncErrorCategory category) {
    return switch (category) {
      SyncErrorCategory.timeout ||
      SyncErrorCategory.connection ||
      SyncErrorCategory.temporarilyUnavailable ||
      SyncErrorCategory.rateLimited ||
      SyncErrorCategory.server => true,
      _ => false,
    };
  }

  Duration delayForAttempt(int attempt) {
    if (attempt <= 1) return initialDelay;
    final multiplier = 1 << (attempt - 2).clamp(0, 16);
    final delay = initialDelay * multiplier;
    return delay > maxDelay ? maxDelay : delay;
  }
}
