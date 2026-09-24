import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Small dependency-free mock of the receiving API contract.
///
/// Run with:
/// dart run tool/mock_health_api.dart --port 8787
///
/// The server intentionally logs counts and operation names only. It never
/// prints record measurements or credentials.
class MockHealthApiServer {
  MockHealthApiServer({
    this.expectedCredential = 'dev-credential',
    this.scenario = 'success',
  });

  final String expectedCredential;
  final String scenario;
  final Map<String, _StoredResponse> _responses = {};
  HttpServer? _server;
  int requestCount = 0;

  Uri get uri {
    final server = _server;
    if (server == null) throw StateError('Mock server is not running.');
    return Uri.parse('http://127.0.0.1:${server.port}');
  }

  Future<void> start({int port = 8787}) async {
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    stdout.writeln(
      'Mock Health API listening on http://127.0.0.1:${_server!.port}',
    );
    stdout.writeln('Scenario: $scenario');
    _server!.listen(_handle);
  }

  Future<void> stop() async {
    final server = _server;
    _server = null;
    await server?.close(force: true);
  }

  Future<void> _handle(HttpRequest request) async {
    requestCount++;
    try {
      if (request.method != 'POST' ||
          request.uri.path != '/v1/health-records') {
        await _writeJson(request, 404, {'error': 'not_found'});
        return;
      }

      final authorization = request.headers.value(
        HttpHeaders.authorizationHeader,
      );
      if (authorization != 'Bearer $expectedCredential') {
        await _writeJson(request, 401, {'error': 'unauthorized'});
        return;
      }

      final idempotencyKey = request.headers.value('idempotency-key');
      if (idempotencyKey == null || idempotencyKey.isEmpty) {
        await _writeJson(request, 400, {'error': 'missing_idempotency_key'});
        return;
      }
      if (request.headers.value('x-schema-version') != '1') {
        await _writeJson(request, 400, {'error': 'unsupported_schema_version'});
        return;
      }

      final rawBody = await utf8.decoder.bind(request).join();
      final Object? decoded;
      try {
        decoded = jsonDecode(rawBody);
      } on FormatException {
        await _writeJson(request, 400, {'error': 'malformed_json'});
        return;
      }
      if (decoded is! Map<String, dynamic>) {
        await _writeJson(request, 400, {'error': 'invalid_envelope'});
        return;
      }
      final operation = decoded['operation'];
      final records = decoded['records'];
      if (operation is! String ||
          records is! List ||
          records.isEmpty ||
          records.length > 100) {
        await _writeJson(request, 400, {'error': 'invalid_records'});
        return;
      }
      if (records.any((record) => record is! Map)) {
        await _writeJson(request, 400, {'error': 'invalid_record'});
        return;
      }

      final previous = _responses[idempotencyKey];
      if (previous != null) {
        if (previous.rawBody != rawBody) {
          await _writeJson(request, 409, {'error': 'idempotency_conflict'});
          return;
        }
        await _writeJson(request, previous.statusCode, previous.body);
        stdout.writeln('POST /v1/health-records duplicate=$idempotencyKey');
        return;
      }

      final response = _responseFor(operation, records);
      _responses[idempotencyKey] = _StoredResponse(
        statusCode: response.statusCode,
        body: response.body,
        rawBody: rawBody,
      );
      await _writeJson(request, response.statusCode, response.body);
      stdout.writeln(
        'POST /v1/health-records operation=$operation records=${records.length}',
      );
    } catch (_) {
      await _writeJson(request, 500, {'error': 'mock_server_error'});
    }
  }

  _MockResponse _responseFor(String operation, List<dynamic> records) {
    if (scenario == '401') {
      return _MockResponse(401, {'error': 'forced_unauthorized'});
    }
    if (scenario == '429') {
      return _MockResponse(429, {'error': 'forced_rate_limit'});
    }
    if (scenario == '500') {
      return _MockResponse(500, {'error': 'forced_server_error'});
    }
    if (scenario == 'malformed') {
      return _MockResponse(200, {'status': 'unexpected-shape'});
    }

    final ids = records
        .whereType<Map>()
        .map((record) => record['record_id'])
        .whereType<String>()
        .toList(growable: false);
    if (scenario == 'reject' || ids.isEmpty) {
      return _MockResponse(400, {
        'error': 'forced_rejection',
        'status': 'rejected',
        'rejected_record_ids': ids,
      });
    }
    return _MockResponse(200, {
      'operation_id': 'mock-$operation',
      'status': 'accepted',
      'accepted': true,
      'accepted_record_ids': ids,
      'rejected_record_ids': const <String>[],
    });
  }

  Future<void> _writeJson(
    HttpRequest request,
    int statusCode,
    Map<String, dynamic> body,
  ) async {
    request.response
      ..statusCode = statusCode
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(body));
    await request.response.close();
  }
}

class _MockResponse {
  const _MockResponse(this.statusCode, this.body);

  final int statusCode;
  final Map<String, dynamic> body;
}

class _StoredResponse {
  const _StoredResponse({
    required this.statusCode,
    required this.body,
    required this.rawBody,
  });

  final int statusCode;
  final Map<String, dynamic> body;
  final String rawBody;
}

Future<void> main(List<String> arguments) async {
  if (arguments.contains('--help') || arguments.contains('-h')) {
    stdout.writeln(
      'Usage: dart run tool/mock_health_api.dart '
      '[--port 8787] [--credential dev-credential] '
      '[--scenario success|reject|401|429|500|malformed]',
    );
    return;
  }
  final portIndex = arguments.indexOf('--port');
  final credentialIndex = arguments.indexOf('--credential');
  final scenarioIndex = arguments.indexOf('--scenario');
  final port = portIndex >= 0 ? int.tryParse(arguments[portIndex + 1]) : 8787;
  final credential = credentialIndex >= 0
      ? arguments[credentialIndex + 1]
      : 'dev-credential';
  final scenario = scenarioIndex >= 0
      ? arguments[scenarioIndex + 1]
      : 'success';
  final server = MockHealthApiServer(
    expectedCredential: credential,
    scenario: scenario,
  );
  await server.start(port: port ?? 8787);
  await ProcessSignal.sigint.watch().first;
  await server.stop();
}
