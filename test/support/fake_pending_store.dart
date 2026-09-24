import 'package:flutter_stats/data/persistence/in_memory_pending_store.dart';

class FakePendingStore extends InMemoryPendingStore {
  FakePendingStore({super.initial, super.cursors});
}
