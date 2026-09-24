import 'package:dio/dio.dart';

import '../../core/errors/sync_error.dart';
import '../../core/logging/redacting_logger.dart';
import '../../features/sync/domain/models.dart';
import 'api_mapper.dart';
import 'api_models.dart';

abstract interface class InstallationCredentialProvider {
  Future<String?> readCredential();

  Future<void> writeCredential(String credential);

  Future<void> clear();
}

abstract interface class ReceivingApi {
  Future<ApiAcknowledgement> submit(PendingOperation operation);
}

class ApiAcknowledgement {
  const ApiAcknowledgement({
    required this.accepted,
    this.retryAfter,
    this.acknowledgedRecordIds = const {},
  });

  final bool accepted;
  final Duration? retryAfter;
  final Set<String> acknowledgedRecordIds;
}

class DioReceivingApi implements ReceivingApi {
  DioReceivingApi({
    required this.configuration,
    required this.credentialProvider,
    required this.client,
    this.mapper = const ApiMapper(),
    this.logger = const RedactingLogger(),
  });

  final ApiConfiguration configuration;
  final InstallationCredentialProvider credentialProvider;
  final Dio client;
  final ApiMapper mapper;
  final RedactingLogger logger;

  @override
  Future<ApiAcknowledgement> submit(PendingOperation operation) async {
    if (!configuration.enabled) {
      throw const SyncException(
        SyncErrorCategory.authorization,
        message: 'API delivery is disabled by configuration.',
      );
    }
    final credential = await credentialProvider.readCredential();
    if (credential == null || credential.trim().isEmpty) {
      throw const SyncException(
        SyncErrorCategory.missingCredential,
        message: 'An installation credential is required.',
      );
    }

    final envelope = mapper.map(operation);
    final uri = _buildUri();
    try {
      final response = await client.postUri<Object?>(
        uri,
        data: envelope.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $credential',
            'Content-Type': 'application/json',
            'Idempotency-Key': operation.operationId,
            'X-Schema-Version': configuration.schemaVersion.toString(),
            'X-Client-Version': configuration.clientVersion,
          },
          sendTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      final status = response.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        throw _forStatus(status, response.data);
      }
      final body = response.data;
      final parsed = body is Map
          ? ApiResponseEnvelope.fromJson(Map<String, dynamic>.from(body))
          : const ApiResponseEnvelope(accepted: true);
      if (!parsed.accepted) {
        throw const SyncException(
          SyncErrorCategory.validation,
          message: 'The receiving service did not acknowledge the operation.',
        );
      }
      return ApiAcknowledgement(
        accepted: true,
        retryAfter: parsed.retryAfterSeconds == null
            ? null
            : Duration(seconds: parsed.retryAfterSeconds!),
        acknowledgedRecordIds: parsed.acknowledgedRecordIds,
      );
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status != null) throw _forStatus(status, error.response?.data);
      throw SyncException(
        error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.receiveTimeout ||
                error.type == DioExceptionType.sendTimeout
            ? SyncErrorCategory.timeout
            : SyncErrorCategory.connection,
        message: 'The receiving service could not be reached.',
        retryable: true,
      );
    } on SyncException {
      rethrow;
    } catch (_) {
      throw const SyncException(
        SyncErrorCategory.malformedResponse,
        message: 'The receiving service returned an invalid response.',
      );
    }
  }

  Uri _buildUri() {
    final base = configuration.baseUrl.endsWith('/')
        ? configuration.baseUrl.substring(0, configuration.baseUrl.length - 1)
        : configuration.baseUrl;
    return Uri.parse('$base/v1/health-records');
  }

  SyncException _forStatus(int status, Object? body) {
    final category = switch (status) {
      401 || 403 => SyncErrorCategory.authorization,
      408 || 425 || 429 => SyncErrorCategory.rateLimited,
      >= 500 => SyncErrorCategory.server,
      >= 400 => SyncErrorCategory.validation,
      _ => SyncErrorCategory.malformedResponse,
    };
    final retryable =
        status == 408 || status == 425 || status == 429 || status >= 500;
    return SyncException(
      category,
      message: 'Receiving service response was not successful.',
      statusCode: status,
      retryable: retryable,
    );
  }
}
