import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../domain/sync_status.dart';

final syncStatusProvider = Provider<SyncStatusController>((ref) {
  return ref.read(appDependenciesProvider).statusController;
});
