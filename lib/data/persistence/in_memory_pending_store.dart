import '../../features/sync/domain/models.dart';
import '../health/health_data_source.dart';

class InMemoryPendingStore implements PendingStore {
  InMemoryPendingStore({
    Map<String, PendingOperation>? initial,
    Map<String, String>? cursors,
  }) : _operations = {
         for (final entry in (initial ?? {}).entries) entry.key: entry.value,
       },
       _cursors = {...?cursors};

  final Map<String, PendingOperation> _operations;
  final Map<String, String> _cursors;
  ConnectionSnapshot? _connection;
  SyncRunSnapshot? _run;

  @override
  Future<void> clear() async {
    _operations.clear();
    _cursors.clear();
  }

  @override
  Future<int> countPending() async => _operations.length;

  @override
  Future<void> enqueue(PendingOperation operation) async {
    operation.validate();
    _operations[operation.operationId] = operation;
  }

  @override
  Future<void> enqueueAll(Iterable<PendingOperation> operations) async {
    for (final operation in operations) {
      await enqueue(operation);
    }
  }

  @override
  Future<List<PendingOperation>> pendingOperations({int limit = 100}) async {
    return _operations.values.take(limit).toList(growable: false);
  }

  @override
  Future<Map<String, String>> readCursors() async => Map.of(_cursors);

  @override
  Future<void> remove(String operationId) async {
    _operations.remove(operationId);
  }

  @override
  Future<void> saveCursors(Map<String, String> cursors) async {
    _cursors
      ..clear()
      ..addAll(cursors);
  }

  @override
  Future<void> update(PendingOperation operation) async {
    _operations[operation.operationId] = operation;
  }

  @override
  Future<SyncRunSnapshot?> latestRun() async => _run;

  @override
  Future<void> saveRun(SyncRunSnapshot run) async {
    _run = run;
  }

  @override
  Future<ConnectionSnapshot?> latestConnection() async => _connection;

  @override
  Future<void> saveConnection(ConnectionSnapshot connection) async {
    _connection = connection;
  }
}
