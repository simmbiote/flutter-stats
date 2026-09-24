import 'package:flutter/foundation.dart';

import '../../../core/time/clock.dart';
import '../../../background/sync_scheduler.dart';
import '../../../data/health/health_data_source.dart';
import '../../../data/health/permission_catalog.dart';
import '../../status/domain/sync_status.dart';
import '../../sync/domain/models.dart';

class ConnectionController extends ChangeNotifier {
  ConnectionController({
    required this.source,
    required this.store,
    required this.scheduler,
    required this.statusController,
    this.catalog = const PermissionCatalog(),
    this.clock = const SystemClock(),
  });

  final HealthDataSource source;
  final PendingStore store;
  final SyncScheduler scheduler;
  final SyncStatusController statusController;
  final PermissionCatalog catalog;
  final Clock clock;

  ConnectionSnapshot? snapshot;
  bool busy = false;
  String? safeMessage;

  Future<void> refresh() async {
    try {
      final value = await source.getPermissionSnapshot(
        recordTypes: catalog.recordTypes,
      );
      snapshot = value;
      safeMessage = null;
      await store.saveConnection(value);
      statusController.updateConnection(value);
      notifyListeners();
    } catch (_) {
      safeMessage = 'Health Connect is temporarily unavailable.';
      notifyListeners();
    }
  }

  Future<void> requestPermissions({bool requestBackground = true}) async {
    if (busy) return;
    busy = true;
    safeMessage = null;
    notifyListeners();
    try {
      final value = await source.requestReadPermissions(
        catalog.recordTypes,
        requestBackground: requestBackground,
      );
      snapshot = value;
      await store.saveConnection(value);
      statusController.updateConnection(value);
      if (value.state == ConnectionState.connected) {
        await scheduler.schedulePeriodic();
        await scheduler.scheduleImmediate(reason: 'permission_granted');
      }
    } catch (_) {
      safeMessage = 'Permissions could not be requested.';
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    if (busy) return;
    busy = true;
    notifyListeners();
    try {
      await scheduler.cancel();
      await source.revokeOrDisconnect();
      await store.clear();
      final value = ConnectionSnapshot(
        state: ConnectionState.disconnected,
        availability: HealthAvailability.available,
        permissions: const {},
      );
      snapshot = value;
      await store.saveConnection(value);
      statusController.updateConnection(value);
      safeMessage =
          'Health access is disconnected and pending local data was cleared.';
    } catch (_) {
      safeMessage = 'Disconnect could not be completed.';
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> openSettings() => source.openPermissionSettings();

  DateTime now() => clock.nowUtc();
}
