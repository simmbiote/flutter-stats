import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';

import '../background/sync_scheduler.dart';
import '../background/workmanager_sync_scheduler.dart';
import '../core/config/app_config.dart';
import '../core/ids/id_generator.dart';
import '../core/logging/redacting_logger.dart';
import '../core/time/clock.dart';
import '../data/api/fake_receiving_api.dart';
import '../data/api/receiving_api.dart';
import '../data/credentials/installation_credential_store.dart';
import '../data/health/fake_health_data_source.dart';
import '../data/health/health_connect_data_source.dart';
import '../data/health/health_data_source.dart';
import '../data/persistence/app_database.dart';
import '../data/persistence/encrypted_payload_codec.dart';
import '../data/persistence/in_memory_pending_store.dart';
import '../data/persistence/secure_key_store.dart';
import '../data/persistence/sync_repository.dart';
import '../features/connection/domain/connection_controller.dart';
import '../features/status/domain/sync_status.dart';
import '../features/sync/domain/models.dart';
import '../features/sync/domain/sync_coordinator.dart';

class AppDependencies {
  AppDependencies._({
    required this.config,
    required this.database,
    required this.source,
    required this.store,
    required this.api,
    required this.credentialProvider,
    required this.scheduler,
    required this.statusController,
    required this.connectionController,
    required this.coordinator,
    required this.logger,
  });

  final AppConfig config;
  final AppDatabase database;
  final HealthDataSource source;
  final PendingStore store;
  final ReceivingApi api;
  final InstallationCredentialProvider credentialProvider;
  final SyncScheduler scheduler;
  final SyncStatusController statusController;
  final ConnectionController connectionController;
  final SyncCoordinator coordinator;
  final RedactingLogger logger;
  final List<VoidCallback> _disposers = [];

  static Future<AppDependencies> create({
    AppConfig? config,
    bool useDemo = false,
  }) async {
    final resolvedConfig = config ?? AppConfig.fromEnvironment();
    final logger = RedactingLogger(debugEnabled: false);
    final database = AppDatabase();
    await database.customSelect('SELECT 1').get();
    final keyStore = SecureKeyStore();
    final codec = EncryptedPayloadCodec(keyStore: keyStore);
    final store = DriftPendingStore(database: database, codec: codec);
    final source = useDemo || resolvedConfig.useFakeHealthSource
        ? FakeHealthDataSource()
        : HealthConnectDataSource();
    final credentialProvider = SecureInstallationCredentialProvider();
    final configuration = ApiConfiguration(
      baseUrl: resolvedConfig.apiBaseUrl,
      clientVersion: resolvedConfig.clientVersion,
      enabled: resolvedConfig.hasApiBaseUrl,
    );
    final ReceivingApi api;
    if (useDemo || resolvedConfig.useFakeApi) {
      api = InMemoryReceivingApi();
    } else {
      api = DioReceivingApi(
        configuration: configuration,
        credentialProvider: credentialProvider,
        client: Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 30),
          ),
        ),
        logger: logger,
      );
    }
    final scheduler = Platform.isAndroid
        ? WorkmanagerSyncScheduler()
        : const NoopSyncScheduler();
    final latestRun = await store.latestRun();
    final latestConnection = await store.latestConnection();
    final statusController = SyncStatusController(
      initial: latestRun,
      connection: latestConnection,
    );
    final connectionController = ConnectionController(
      source: source,
      store: store,
      scheduler: scheduler,
      statusController: statusController,
    );
    final coordinator = SyncCoordinator(
      source: source,
      store: store,
      api: api,
      clock: const SystemClock(),
      ids: RandomIdGenerator(),
    );
    final dependencies = AppDependencies._(
      config: resolvedConfig,
      database: database,
      source: source,
      store: store,
      api: api,
      credentialProvider: credentialProvider,
      scheduler: scheduler,
      statusController: statusController,
      connectionController: connectionController,
      coordinator: coordinator,
      logger: logger,
    );
    dependencies._disposers.add(statusController.dispose);
    dependencies._disposers.add(connectionController.dispose);
    return dependencies;
  }

  static AppDependencies demo() {
    final config = const AppConfig(
      apiBaseUrl: 'https://demo.invalid',
      clientVersion: 'demo',
      useFakeHealthSource: true,
      useFakeApi: true,
    );
    final source = FakeHealthDataSource();
    final store = InMemoryPendingStore();
    final api = InMemoryReceivingApi();
    final credentialProvider = InMemoryCredentialProvider();
    final statusController = SyncStatusController();
    final scheduler = const NoopSyncScheduler();
    final connectionController = ConnectionController(
      source: source,
      store: store,
      scheduler: scheduler,
      statusController: statusController,
    );
    final coordinator = SyncCoordinator(
      source: source,
      store: store,
      api: api,
      clock: const SystemClock(),
      ids: RandomIdGenerator(),
    );
    return AppDependencies._(
      config: config,
      database: AppDatabase(NativeDatabase.memory()),
      source: source,
      store: store,
      api: api,
      credentialProvider: credentialProvider,
      scheduler: scheduler,
      statusController: statusController,
      connectionController: connectionController,
      coordinator: coordinator,
      logger: const RedactingLogger(),
    );
  }

  Future<void> runSync({String trigger = 'manual'}) async {
    statusController.setBusy(true);
    try {
      await coordinator.run(
        trigger: trigger,
        onStatus: statusController.update,
      );
    } finally {
      statusController.setBusy(false);
    }
  }

  Future<void> initialize() async {
    await connectionController.refresh();
    if (config.enableAutomaticSync &&
        connectionController.snapshot?.state == ConnectionState.connected) {
      await scheduler.schedulePeriodic();
    }
  }

  Future<void> dispose() async {
    for (final dispose in _disposers) {
      dispose();
    }
    await database.close();
  }
}
