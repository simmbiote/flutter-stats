import 'package:flutter_stats/background/sync_scheduler.dart';

class FakeSyncScheduler implements SyncScheduler {
  int periodicCalls = 0;
  int immediateCalls = 0;
  int cancelCalls = 0;
  String? lastReason;

  @override
  Future<void> cancel() async {
    cancelCalls++;
  }

  @override
  Future<void> scheduleImmediate({String reason = 'manual'}) async {
    immediateCalls++;
    lastReason = reason;
  }

  @override
  Future<void> schedulePeriodic() async {
    periodicCalls++;
  }
}
