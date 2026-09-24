import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/connection/presentation/connection_page.dart';
import 'dependencies.dart';

final appDependenciesProvider = Provider<AppDependencies>((ref) {
  throw StateError('AppDependencies must be provided at the root.');
});

class FlutterStatsApp extends StatelessWidget {
  const FlutterStatsApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [appDependenciesProvider.overrideWithValue(dependencies)],
      child: MaterialApp(
        title: 'Flutter Stats',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const ConnectionPage(),
      ),
    );
  }
}
