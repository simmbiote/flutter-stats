import 'package:flutter/foundation.dart';

import '../../../features/sync/domain/models.dart';

class SyncStatusController extends ChangeNotifier {
  SyncStatusController({
    SyncRunSnapshot? initial,
    ConnectionSnapshot? connection,
  }) : _snapshot =
           initial ??
           SyncRunSnapshot(
             receiveState: SyncReceiveState.waiting,
             sendState: SyncSendState.waiting,
             startedAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
           ),
       _connection = connection;

  SyncRunSnapshot _snapshot;
  ConnectionSnapshot? _connection;
  bool _busy = false;

  SyncRunSnapshot get snapshot => _snapshot;
  ConnectionSnapshot? get connection => _connection;
  bool get busy => _busy;

  void setBusy(bool value) {
    if (_busy == value) return;
    _busy = value;
    notifyListeners();
  }

  void updateConnection(ConnectionSnapshot value) {
    _connection = value;
    notifyListeners();
  }

  void update(SyncRunSnapshot value) {
    _snapshot = value;
    notifyListeners();
  }

  void clearError() {
    update(_snapshot.copyWith(clearSafeError: true));
  }
}
