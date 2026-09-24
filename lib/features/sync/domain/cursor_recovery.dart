import '../domain/models.dart';

class CursorRecovery {
  const CursorRecovery();

  bool shouldReset(Map<String, String> cursors, SourceReadResult result) {
    return result.tokenExpired || cursors.isEmpty;
  }

  Map<String, String> recoveredCursors(
    Map<String, String> cursors,
    SourceReadResult result,
  ) {
    if (result.tokenExpired) return <String, String>{};
    return {...cursors, ...result.cursors};
  }

  DateTime recoveryStart(DateTime now) =>
      now.subtract(const Duration(days: 30));
}
