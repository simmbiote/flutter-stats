import 'package:flutter_stats/core/errors/sync_error.dart';
import 'package:flutter_stats/data/api/receiving_api.dart';
import 'package:flutter_stats/features/sync/domain/models.dart';

class FakeReceivingApi implements ReceivingApi {
  FakeReceivingApi({this.failuresRemaining = 0, this.failure});

  int failuresRemaining;
  SyncErrorCategory? failure;
  final List<PendingOperation> submitted = [];

  @override
  Future<ApiAcknowledgement> submit(PendingOperation operation) async {
    submitted.add(operation);
    if (failuresRemaining > 0) {
      failuresRemaining--;
      final category = failure ?? SyncErrorCategory.server;
      throw SyncException(
        category,
        retryable: category != SyncErrorCategory.validation,
      );
    }
    return ApiAcknowledgement(
      accepted: true,
      acknowledgedRecordIds: {operation.identity.sourceRecordId},
    );
  }
}
