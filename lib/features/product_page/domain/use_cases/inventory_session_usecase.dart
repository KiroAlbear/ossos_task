import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

import '../../data/models/inventory_session_model.dart';
import '../../data/models/inventory_session_request_model.dart';
import '../repositories/inventory_session_repository.dart';

class InventorySessionUseCase
    extends UseCase<InventorySessionModel, InventorySessionParams> {
  final InventorySessionRepository _repository;

  InventorySessionUseCase(this._repository);

  @override
  Future<Either<Failure, InventorySessionModel>> call(
    InventorySessionParams params,
  ) {
    return _repository.submitInventorySession(params.request);
  }
}

class InventorySessionParams {
  /// Reuse this request on retry to preserve the client session ID and timestamp.
  final InventorySessionRequestModel request;

  const InventorySessionParams({required this.request});
}
