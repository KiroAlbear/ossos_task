import 'package:dartz/dartz.dart';
import 'package:ossos_task/core/models/error_handling_models/src/failure.dart';

import '../../domain/repositories/inventory_session_repository.dart';
import '../data_sources/inventory_session_remote_datasource.dart';
import '../models/inventory_session_model.dart';
import '../models/inventory_session_request_model.dart';

class InventorySessionRepositoryImp implements InventorySessionRepository {
  final InventorySessionRemoteDataSource _dataSource;

  InventorySessionRepositoryImp(this._dataSource);

  @override
  Future<Either<Failure, InventorySessionModel>> submitInventorySession(
    InventorySessionRequestModel request,
  ) => _dataSource.submitInventorySession(request);
}
