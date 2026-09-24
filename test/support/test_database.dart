import 'package:drift/native.dart';
import 'package:flutter_stats/data/persistence/app_database.dart';

AppDatabase createTestDatabase() => AppDatabase(NativeDatabase.memory());
