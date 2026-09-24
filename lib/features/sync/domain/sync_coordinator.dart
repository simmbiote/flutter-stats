import 'dart:async';

import '../../../core/errors/health_errors.dart';
import '../../../core/errors/sync_error.dart';
import '../../../core/ids/id_generator.dart';
import '../../../core/time/clock.dart';
import '../../../data/api/receiving_api.dart';
import '../../../data/health/health_data_source.dart';
import '../../../data/health/permission_catalog.dart';
import '../domain/models.dart';
import 'cursor_recovery.dart';
import 'retry_scheduler.dart';

class SyncCoordinator {
  SyncCoordinator({
    required this.source,
    required this.store,
    required this.api,
    required this.clock,
    required this.ids,
    this.retryPolicy = const RetryPolicy(),
    this.catalog = const PermissionCatalog(),
  });

  final HealthDataSource source;
  final PendingStore store;
  final ReceivingApi api;
  final Clock clock;
  final IdGenerator ids;
  final RetryPolicy retryPolicy;
  final PermissionCatalog catalog;
  final CursorRecovery cursorRecovery = const CursorRecovery();
  late final RetryScheduler retryScheduler = RetryScheduler(
    policy: retryPolicy,
  );
  bool _running = false;

  bool get isRunning => _running;

  Future<SyncRunSnapshot> run({
    String trigger = 'manual',
    void Function(SyncRunSnapshot snapshot)? onStatus,
  }) async {
    if (_running) {
      final current = await store.latestRun();
      return current ??
          SyncRunSnapshot(
            receiveState: SyncReceiveState.waiting,
            sendState: SyncSendState.waiting,
            startedAt: clock.nowUtc(),
          );
    }
    _running = true;
    final startedAt = clock.nowUtc();
    var snapshot = SyncRunSnapshot(
      receiveState: SyncReceiveState.receiving,
      sendState: SyncSendState.waiting,
      startedAt: startedAt,
    );
    void publish(SyncRunSnapshot next) {
      snapshot = next;
      onStatus?.call(next);
    }

    try {
      final connection = await source.getPermissionSnapshot(
        recordTypes: catalog.recordTypes,
      );
      if (connection.availability != HealthAvailability.available) {
        publish(
          snapshot.copyWith(
            receiveState: SyncReceiveState.blocked,
            sendState: SyncSendState.blocked,
            safeErrorCategory: SyncErrorCategory.unavailable,
            finishedAt: clock.nowUtc(),
            pendingCount: await store.countPending(),
          ),
        );
        await _saveRun(snapshot);
        return snapshot;
      }
      if (!connection.canRead) {
        publish(
          snapshot.copyWith(
            receiveState: SyncReceiveState.blocked,
            sendState: SyncSendState.blocked,
            safeErrorCategory: SyncErrorCategory.permissionDenied,
            finishedAt: clock.nowUtc(),
            pendingCount: await store.countPending(),
          ),
        );
        await _saveRun(snapshot);
        return snapshot;
      }

      final cursors = await store.readCursors();
      final allRecordTypes = catalog.recordTypes;
      SourceReadResult readResult;
      if (cursors.isEmpty) {
        final end = clock.nowUtc();
        readResult = await source.readInitialWindow(
          start: end.subtract(const Duration(days: 30)),
          end: end,
          recordTypes: allRecordTypes,
        );
        final operations = readResult.records.map(_operationForRecord).toList();
        await store.enqueueAll(operations);
      } else {
        readResult = await source.readChanges(
          cursors: cursors,
          recordTypes: allRecordTypes,
        );
        final operations = readResult.changes.map(_operationForChange).toList();
        await store.enqueueAll(operations);
      }
      final mergedCursors = cursorRecovery.recoveredCursors(
        cursors,
        readResult,
      );
      await store.saveCursors(mergedCursors);
      publish(
        snapshot.copyWith(
          receiveState: readResult.records.isEmpty && readResult.changes.isEmpty
              ? SyncReceiveState.empty
              : SyncReceiveState.complete,
          pendingCount: await store.countPending(),
        ),
      );

      final sendResult = await _sendPending(publish, snapshot);
      final finished = clock.nowUtc();
      final finalSnapshot = sendResult.copyWith(
        receiveState: snapshot.receiveState,
        finishedAt: finished,
        pendingCount: await store.countPending(),
      );
      await _saveRun(finalSnapshot);
      publish(finalSnapshot);
      return finalSnapshot;
    } on HealthDataSourceException catch (error) {
      final failed = snapshot.copyWith(
        receiveState: error.category == SyncErrorCategory.permissionDenied
            ? SyncReceiveState.blocked
            : SyncReceiveState.failed,
        sendState: SyncSendState.waiting,
        safeErrorCategory: error.category,
        finishedAt: clock.nowUtc(),
        pendingCount: await store.countPending(),
      );
      await _saveRun(failed);
      publish(failed);
      return failed;
    } on SyncException catch (error) {
      final failed = snapshot.copyWith(
        receiveState: SyncReceiveState.failed,
        sendState: SyncSendState.failed,
        safeErrorCategory: error.category,
        finishedAt: clock.nowUtc(),
        pendingCount: await store.countPending(),
      );
      await _saveRun(failed);
      publish(failed);
      return failed;
    } catch (_) {
      final failed = snapshot.copyWith(
        receiveState: SyncReceiveState.failed,
        sendState: SyncSendState.failed,
        safeErrorCategory: SyncErrorCategory.unknown,
        finishedAt: clock.nowUtc(),
        pendingCount: await store.countPending(),
      );
      await _saveRun(failed);
      publish(failed);
      return failed;
    } finally {
      _running = false;
    }
  }

  Future<SyncRunSnapshot> _sendPending(
    void Function(SyncRunSnapshot) publish,
    SyncRunSnapshot current,
  ) async {
    final operations = await store.pendingOperations();
    if (operations.isEmpty) {
      return current.copyWith(
        sendState: SyncSendState.empty,
        clearSafeError: true,
      );
    }
    var state = current.copyWith(sendState: SyncSendState.sending);
    publish(state);
    var hadRetry = false;
    var hadBlocked = false;
    var hadFailure = false;
    var hadAcknowledgement = false;
    DateTime? lastSuccess;
    for (final operation in operations) {
      final sending = operation.copyWith(
        state: PendingOperationState.sending,
        attempts: operation.attempts + 1,
        leaseUntil: clock.nowUtc().add(const Duration(minutes: 5)),
      );
      await store.update(sending);
      try {
        final acknowledgement = await _submit(sending);
        if (acknowledgement.accepted) {
          await store.remove(sending.operationId);
          hadAcknowledgement = true;
          lastSuccess = clock.nowUtc();
        } else {
          throw const SyncException(SyncErrorCategory.malformedResponse);
        }
      } catch (error) {
        final category = _categoryFor(error);
        final decision = retryScheduler.decide(
          category: category,
          attempt: sending.attempts,
          now: clock.nowUtc(),
        );
        final retryable = decision.shouldRetry;
        final exhausted = retryPolicy.isRetryable(category) && !retryable;
        final nextState = retryable
            ? PendingOperationState.retryScheduled
            : PendingOperationState.blocked;
        final updated = sending.copyWith(
          state: nextState,
          nextAttemptAt: decision.nextAttemptAt,
          clearNextAttemptAt: !retryable,
          lastErrorCategory: category,
          clearLease: true,
        );
        await store.update(updated);
        hadRetry |= retryable;
        hadFailure |= exhausted;
        hadBlocked |= !retryable && !exhausted;
      }
    }
    state = state.copyWith(
      sendState: hadRetry
          ? SyncSendState.retryScheduled
          : hadFailure
          ? SyncSendState.failed
          : hadBlocked
          ? SyncSendState.blocked
          : hadAcknowledgement
          ? SyncSendState.sent
          : SyncSendState.failed,
      lastSuccessfulSyncAt: lastSuccess,
      pendingCount: await store.countPending(),
      safeErrorCategory: hadRetry
          ? SyncErrorCategory.temporarilyUnavailable
          : hadFailure
          ? SyncErrorCategory.server
          : hadBlocked
          ? SyncErrorCategory.authorization
          : null,
      clearSafeError: !hadRetry && !hadFailure && !hadBlocked,
    );
    if (!hadRetry &&
        !hadFailure &&
        !hadBlocked &&
        await store.countPending() > 0) {
      return _sendPending(publish, state);
    }
    return state;
  }

  Future<ApiAcknowledgement> _submit(PendingOperation operation) async {
    return api.submit(operation);
  }

  PendingOperation _operationForRecord(HealthRecordSnapshot record) {
    record.validate();
    return PendingOperation(
      operationId: _operationId(record, HealthRecordOperation.upsert),
      identity: record.identity,
      operation: HealthRecordOperation.upsert,
      state: PendingOperationState.pending,
      createdAt: clock.nowUtc(),
      payload: record,
    );
  }

  PendingOperation _operationForChange(SourceChange change) {
    if (change.operation == HealthRecordOperation.upsert) {
      final record = change.record;
      if (record == null) {
        throw const SyncException(SyncErrorCategory.invalidData);
      }
      return _operationForRecord(record);
    }
    return PendingOperation(
      operationId: _operationIdForIdentity(
        change.identity,
        HealthRecordOperation.delete,
        'deleted',
      ),
      identity: change.identity,
      operation: HealthRecordOperation.delete,
      state: PendingOperationState.pending,
      createdAt: clock.nowUtc(),
    );
  }

  String _operationId(
    HealthRecordSnapshot record,
    HealthRecordOperation operation,
  ) =>
      _operationIdForIdentity(record.identity, operation, record.sourceVersion);

  String _operationIdForIdentity(
    HealthRecordIdentity identity,
    HealthRecordOperation operation,
    String version,
  ) => '${identity.key}|${operation.name}|$version';

  SyncErrorCategory _categoryFor(Object error) {
    if (error is SyncException) return error.category;
    return SyncErrorCategory.unknown;
  }

  Future<void> _saveRun(SyncRunSnapshot snapshot) => store.saveRun(snapshot);
}
