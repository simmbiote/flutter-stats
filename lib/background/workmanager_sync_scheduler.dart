import 'package:workmanager/workmanager.dart';

import 'sync_scheduler.dart';

class WorkmanagerSyncScheduler implements SyncScheduler {
  WorkmanagerSyncScheduler({Workmanager? workmanager})
    : _workmanager = workmanager ?? Workmanager();

  static const periodicTaskName = 'health_connect_periodic_sync';
  static const immediateTaskName = 'health_connect_immediate_sync';
  static const workerTaskName = 'health_connect_sync_worker';

  final Workmanager _workmanager;

  @override
  Future<void> schedulePeriodic() async {
    await _workmanager.registerPeriodicTask(
      periodicTaskName,
      workerTaskName,
      frequency: const Duration(minutes: 15),
      inputData: const {'trigger': 'periodic'},
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 5),
      tag: periodicTaskName,
    );
  }

  @override
  Future<void> scheduleImmediate({String reason = 'manual'}) async {
    await _workmanager.registerOneOffTask(
      immediateTaskName,
      workerTaskName,
      inputData: {'reason': reason},
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 5),
      tag: immediateTaskName,
    );
  }

  @override
  Future<void> cancel() async {
    await _workmanager.cancelByUniqueName(periodicTaskName);
    await _workmanager.cancelByUniqueName(immediateTaskName);
  }
}

class NoopSyncScheduler implements SyncScheduler {
  const NoopSyncScheduler();

  @override
  Future<void> cancel() async {}

  @override
  Future<void> scheduleImmediate({String reason = 'manual'}) async {}

  @override
  Future<void> schedulePeriodic() async {}
}
