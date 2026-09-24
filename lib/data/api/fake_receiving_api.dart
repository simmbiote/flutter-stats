import '../../features/sync/domain/models.dart';
import 'receiving_api.dart';

class InMemoryReceivingApi implements ReceivingApi {
  InMemoryReceivingApi({this.accept = true});

  bool accept;
  final List<PendingOperation> submitted = [];

  @override
  Future<ApiAcknowledgement> submit(PendingOperation operation) async {
    submitted.add(operation);
    if (!accept) {
      throw const _DemoApiException();
    }
    return ApiAcknowledgement(
      accepted: true,
      acknowledgedRecordIds: {operation.identity.sourceRecordId},
    );
  }
}

class _DemoApiException implements Exception {
  const _DemoApiException();
}
