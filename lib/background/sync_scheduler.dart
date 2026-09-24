abstract interface class SyncScheduler {
  Future<void> schedulePeriodic();

  Future<void> scheduleImmediate({String reason = 'manual'});

  Future<void> cancel();
}
