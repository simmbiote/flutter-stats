import 'dart:convert';

import 'package:drift/drift.dart';

import '../../features/sync/domain/models.dart';
import '../health/health_data_source.dart';
import 'app_database.dart';
import 'encrypted_payload_codec.dart';

class DriftPendingStore implements PendingStore {
  DriftPendingStore({required this.database, required this.codec});

  final AppDatabase database;
  final EncryptedPayloadCodec codec;

  @override
  Future<List<PendingOperation>> pendingOperations({int limit = 100}) async {
    final rows =
        await (database.select(database.pendingOperations)
              ..orderBy([(row) => OrderingTerm.asc(row.createdAt)])
              ..limit(limit))
            .get();
    return Future.wait(rows.map(_rowToOperation));
  }

  @override
  Future<void> enqueue(PendingOperation operation) async {
    operation.validate();
    final encrypted = operation.payload == null
        ? null
        : await codec.encode(operation);
    await database
        .into(database.pendingOperations)
        .insert(
          PendingOperationsCompanion.insert(
            id: operation.operationId,
            operationId: operation.operationId,
            sourcePlatform: operation.identity.sourcePlatform,
            sourceRecordId: operation.identity.sourceRecordId,
            recordType: operation.identity.recordType,
            operation: operation.operation.name,
            encryptedPayload: encrypted == null
                ? const Value.absent()
                : Value(encrypted),
            state: operation.state.name,
            attempts: Value(operation.attempts),
            createdAt: operation.createdAt,
            nextAttemptAt: operation.nextAttemptAt == null
                ? const Value.absent()
                : Value(operation.nextAttemptAt!),
            lastErrorCategory: operation.lastErrorCategory == null
                ? const Value.absent()
                : Value(operation.lastErrorCategory!.name),
            leaseUntil: operation.leaseUntil == null
                ? const Value.absent()
                : Value(operation.leaseUntil!),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<void> enqueueAll(Iterable<PendingOperation> operations) async {
    for (final operation in operations) {
      await enqueue(operation);
    }
  }

  @override
  Future<void> update(PendingOperation operation) async {
    final encrypted = operation.payload == null
        ? null
        : await codec.encode(operation);
    await (database.update(
      database.pendingOperations,
    )..where((row) => row.operationId.equals(operation.operationId))).write(
      PendingOperationsCompanion(
        encryptedPayload: encrypted == null
            ? const Value(null)
            : Value(encrypted),
        state: Value(operation.state.name),
        attempts: Value(operation.attempts),
        nextAttemptAt: operation.nextAttemptAt == null
            ? const Value(null)
            : Value(operation.nextAttemptAt!),
        lastErrorCategory: operation.lastErrorCategory == null
            ? const Value(null)
            : Value(operation.lastErrorCategory!.name),
        leaseUntil: operation.leaseUntil == null
            ? const Value(null)
            : Value(operation.leaseUntil!),
      ),
    );
  }

  @override
  Future<void> remove(String operationId) async {
    await (database.delete(
      database.pendingOperations,
    )..where((row) => row.operationId.equals(operationId))).go();
  }

  @override
  Future<int> countPending() async {
    final count = await database.pendingOperations.count().getSingle();
    return count;
  }

  @override
  Future<void> clear() async {
    await database.clearSensitiveData();
  }

  @override
  Future<Map<String, String>> readCursors() async {
    final rows = await database.select(database.syncCursors).get();
    final cursors = <String, String>{};
    for (final row in rows) {
      cursors[row.recordType] = await codec.decryptText(row.token);
    }
    return cursors;
  }

  @override
  Future<void> saveCursors(Map<String, String> cursors) async {
    final encrypted = <String, String>{};
    for (final entry in cursors.entries) {
      encrypted[entry.key] = await codec.encryptText(entry.value);
    }
    await database.transaction(() async {
      await database.delete(database.syncCursors).go();
      for (final entry in encrypted.entries) {
        await database
            .into(database.syncCursors)
            .insert(
              SyncCursorsCompanion.insert(
                recordType: entry.key,
                token: entry.value,
                updatedAt: DateTime.now().toUtc(),
              ),
            );
      }
    });
  }

  @override
  Future<SyncRunSnapshot?> latestRun() async {
    final row =
        await (database.select(database.syncRuns)
              ..orderBy([(item) => OrderingTerm.desc(item.id)])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    return SyncRunSnapshot(
      receiveState: SyncReceiveState.values.firstWhere(
        (value) => value.name == row.receiveState,
        orElse: () => SyncReceiveState.waiting,
      ),
      sendState: SyncSendState.values.firstWhere(
        (value) => value.name == row.sendState,
        orElse: () => SyncSendState.waiting,
      ),
      startedAt: row.startedAt,
      finishedAt: row.finishedAt,
      lastSuccessfulSyncAt: row.lastSuccessfulSyncAt,
      pendingCount: row.pendingCount,
      categoryCounts: _decodeCountMap(row.categoryCounts),
      sourceCounts: _decodeCountMap(row.sourceCounts),
      safeErrorCategory: _decodeError(row.safeErrorCategory),
      automaticProcessing: row.automaticProcessing,
    );
  }

  @override
  Future<void> saveRun(SyncRunSnapshot run) async {
    await database
        .into(database.syncRuns)
        .insert(
          SyncRunsCompanion.insert(
            receiveState: run.receiveState.name,
            sendState: run.sendState.name,
            startedAt: run.startedAt,
            finishedAt: run.finishedAt == null
                ? const Value.absent()
                : Value(run.finishedAt!),
            lastSuccessfulSyncAt: run.lastSuccessfulSyncAt == null
                ? const Value.absent()
                : Value(run.lastSuccessfulSyncAt!),
            pendingCount: Value(run.pendingCount),
            categoryCounts: Value(jsonEncode(run.categoryCounts)),
            sourceCounts: Value(jsonEncode(run.sourceCounts)),
            safeErrorCategory: run.safeErrorCategory == null
                ? const Value.absent()
                : Value(run.safeErrorCategory!.name),
            automaticProcessing: Value(run.automaticProcessing),
          ),
        );
  }

  @override
  Future<ConnectionSnapshot?> latestConnection() async {
    final row =
        await (database.select(database.connectionSnapshots)
              ..where((item) => item.id.equals(1))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    return ConnectionSnapshot.fromJson({
      'state': row.state,
      'availability': row.availability,
      'permissions': jsonDecode(row.permissions),
      'background_read_available': row.backgroundReadAvailable,
      'background_read_authorized': row.backgroundReadAuthorized,
      if (row.updatedAt != null) 'updated_at': row.updatedAt!.toIso8601String(),
      if (row.safeErrorCategory != null)
        'safe_error_category': row.safeErrorCategory,
    });
  }

  @override
  Future<void> saveConnection(ConnectionSnapshot connection) async {
    await database
        .into(database.connectionSnapshots)
        .insert(
          ConnectionSnapshotsCompanion.insert(
            id: const Value(1),
            state: connection.state.name,
            availability: connection.availability.name,
            permissions: Value(
              jsonEncode(
                connection.permissions.map(
                  (key, value) => MapEntry(key, value.name),
                ),
              ),
            ),
            backgroundReadAvailable: Value(connection.backgroundReadAvailable),
            backgroundReadAuthorized: Value(
              connection.backgroundReadAuthorized,
            ),
            updatedAt: connection.updatedAt == null
                ? const Value.absent()
                : Value(connection.updatedAt!),
            safeErrorCategory: connection.safeErrorCategory == null
                ? const Value.absent()
                : Value(connection.safeErrorCategory!.name),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<PendingOperation> _rowToOperation(PendingOperationRow row) async {
    final encoded = row.encryptedPayload;
    final decoded = encoded == null ? null : await codec.decode(encoded);
    return PendingOperation(
      operationId: row.operationId,
      identity: HealthRecordIdentity(
        sourcePlatform: row.sourcePlatform,
        sourceRecordId: row.sourceRecordId,
        recordType: row.recordType,
      ),
      operation: HealthRecordOperation.values.firstWhere(
        (value) => value.name == row.operation,
      ),
      state: PendingOperationState.values.firstWhere(
        (value) => value.name == row.state,
      ),
      createdAt: row.createdAt,
      payload: decoded?.payload,
      attempts: row.attempts,
      nextAttemptAt: row.nextAttemptAt,
      lastErrorCategory: _decodeError(row.lastErrorCategory),
      leaseUntil: row.leaseUntil,
    );
  }
}

Map<String, int> _decodeCountMap(String value) {
  final decoded = jsonDecode(value);
  if (decoded is! Map) return const {};
  return decoded.map((key, item) => MapEntry('$key', (item as num).toInt()));
}

SyncErrorCategory? _decodeError(String? value) {
  if (value == null) return null;
  for (final category in SyncErrorCategory.values) {
    if (category.name == value) return category;
  }
  return null;
}
