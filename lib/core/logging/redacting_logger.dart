import 'dart:developer' as developer;

class RedactingLogger {
  const RedactingLogger({this.debugEnabled = false});

  final bool debugEnabled;

  void debug(String message, {Map<String, Object?> context = const {}}) {
    if (debugEnabled) {
      developer.log(_redact(message), name: 'flutter_stats', level: 800);
    }
  }

  void info(String message, {Map<String, Object?> context = const {}}) {
    developer.log(_redact(message), name: 'flutter_stats', level: 800);
  }

  void warn(String message, {Map<String, Object?> context = const {}}) {
    developer.log(_redact(message), name: 'flutter_stats', level: 900);
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      _redact(message),
      name: 'flutter_stats',
      level: 1000,
      error: error == null ? null : _redact(error.toString()),
      stackTrace: stackTrace,
    );
  }

  String _redact(String value) {
    final secretPattern = RegExp(
      r'(authorization|bearer|token|credential|password)[\s:=]+[^\s,;]+',
      caseSensitive: false,
    );
    final healthValuePattern = RegExp(
      r'(health[_ -]?value|measurement|payload)[\s:=]+[^\s,;]+',
      caseSensitive: false,
    );
    return value
        .replaceAll(secretPattern, r'$1=[REDACTED]')
        .replaceAll(healthValuePattern, r'$1=[REDACTED]');
  }
}
