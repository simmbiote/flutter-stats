import '../../features/sync/domain/models.dart';

class HealthDataSourceException implements Exception {
  const HealthDataSourceException(
    this.category, {
    this.message,
    this.retryable = false,
  });

  final SyncErrorCategory category;
  final String? message;
  final bool retryable;

  @override
  String toString() => 'HealthDataSourceException(${category.name})';
}
