import 'package:dartz/dartz.dart';
import 'package:ossos_task/core/models/error_handling_models/src/failure.dart';

import '../../data/models/inventory_session_model.dart';
import '../../data/models/inventory_session_request_model.dart';

abstract class InventorySessionRepository {
  Future<Either<Failure, InventorySessionModel>> submitInventorySession(
    InventorySessionRequestModel request,
  );
}
