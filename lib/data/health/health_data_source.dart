import '../../features/sync/domain/models.dart';

abstract interface class HealthDataSource {
  Future<HealthAvailability> checkAvailability();

  Future<ConnectionSnapshot> getPermissionSnapshot({List<String>? recordTypes});

  Future<ConnectionSnapshot> requestReadPermissions(
    List<String> recordTypes, {
    bool requestBackground = false,
  });

  Future<void> revokeOrDisconnect();

  Future<void> openPermissionSettings();

  Future<SourceReadResult> readInitialWindow({
    required DateTime start,
    required DateTime end,
    required List<String> recordTypes,
  });

  Future<SourceReadResult> readChanges({
    required Map<String, String> cursors,
    required List<String> recordTypes,
  });
}

abstract interface class PendingStore {
  Future<List<PendingOperation>> pendingOperations({int limit = 100});

  Future<void> enqueue(PendingOperation operation);

  Future<void> enqueueAll(Iterable<PendingOperation> operations);

  Future<void> update(PendingOperation operation);

  Future<void> remove(String operationId);

  Future<int> countPending();

  Future<void> clear();

  Future<Map<String, String>> readCursors();

  Future<void> saveCursors(Map<String, String> cursors);

  Future<SyncRunSnapshot?> latestRun();

  Future<void> saveRun(SyncRunSnapshot run);

  Future<ConnectionSnapshot?> latestConnection();

  Future<void> saveConnection(ConnectionSnapshot connection);
}
