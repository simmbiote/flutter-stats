import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('PendingOperationRow')
class PendingOperations extends Table {
  TextColumn get id => text()();
  TextColumn get operationId => text().unique()();
  TextColumn get sourcePlatform => text()();
  TextColumn get sourceRecordId => text()();
  TextColumn get recordType => text()();
  TextColumn get operation => text()();
  TextColumn get encryptedPayload => text().nullable()();
  TextColumn get state => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get lastErrorCategory => text().nullable()();
  DateTimeColumn get leaseUntil => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SyncCursorRow')
class SyncCursors extends Table {
  TextColumn get recordType => text()();
  TextColumn get token => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {recordType};
}

@DataClassName('SyncRunRow')
class SyncRuns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get receiveState => text()();
  TextColumn get sendState => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  DateTimeColumn get lastSuccessfulSyncAt => dateTime().nullable()();
  IntColumn get pendingCount => integer().withDefault(const Constant(0))();
  TextColumn get categoryCounts => text().withDefault(const Constant('{}'))();
  TextColumn get sourceCounts => text().withDefault(const Constant('{}'))();
  TextColumn get safeErrorCategory => text().nullable()();
  BoolColumn get automaticProcessing =>
      boolean().withDefault(const Constant(true))();
}

@DataClassName('ConnectionSnapshotRow')
class ConnectionSnapshots extends Table {
  IntColumn get id => integer()();
  TextColumn get state => text()();
  TextColumn get availability => text()();
  TextColumn get permissions => text().withDefault(const Constant('{}'))();
  BoolColumn get backgroundReadAvailable =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get backgroundReadAuthorized =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get safeErrorCategory => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ApiConfigurationRow')
class ApiConfigurations extends Table {
  IntColumn get id => integer()();
  TextColumn get baseUrl => text()();
  TextColumn get clientVersion => text()();
  IntColumn get schemaVersion => integer().withDefault(const Constant(1))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('RecordIdentityRow')
class RecordIdentityIndex extends Table {
  TextColumn get sourcePlatform => text()();
  TextColumn get sourceRecordId => text()();
  TextColumn get recordType => text()();
  TextColumn get lastMutationId => text().nullable()();
  TextColumn get lastVersion => text().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {
    sourcePlatform,
    sourceRecordId,
    recordType,
  };
}

@DriftDatabase(
  tables: [
    PendingOperations,
    SyncCursors,
    SyncRuns,
    ConnectionSnapshots,
    ApiConfigurations,
    RecordIdentityIndex,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'flutter_stats_sync'));

  @override
  int get schemaVersion => 1;

  Future<void> clearSensitiveData() async {
    await transaction(() async {
      await delete(pendingOperations).go();
      await delete(syncCursors).go();
      await delete(recordIdentityIndex).go();
      await delete(connectionSnapshots).go();
    });
  }
}
