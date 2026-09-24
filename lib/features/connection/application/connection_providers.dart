import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app.dart';
import '../domain/connection_controller.dart';

final connectionControllerProvider = Provider<ConnectionController>((ref) {
  return ref.read(appDependenciesProvider).connectionController;
});
