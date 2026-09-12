import 'package:dartz/dartz.dart';

import 'package:ossos_task/imports.dart';

import '../../domain/failures/inventory_session_conflict_failure.dart';
import '../models/inventory_session_conflict_model.dart';
import '../models/inventory_session_model.dart';
import '../models/inventory_session_request_model.dart';

abstract class InventorySessionRemoteDataSource {
  Future<Either<Failure, InventorySessionModel>> submitInventorySession(
    InventorySessionRequestModel request,
  );
}

class InventorySessionRemoteDataSourceImpl
    with ApiHelperMixin, RepositoryHelperMixin
    implements InventorySessionRemoteDataSource {
  /// The backend submission URL must be supplied when wiring this feature.
  final String endpoint;
  final bool authorizedApi;

  InventorySessionRemoteDataSourceImpl({
    required this.endpoint,
    this.authorizedApi = false,
  });

  @override
  Future<Either<Failure, InventorySessionModel>> submitInventorySession(
    InventorySessionRequestModel request,
  ) async {

    return await apiCallWrapper<InventorySessionModel>(() {
      return fetchData<InventorySessionModel>(
        "https://mocki.io/v1/b56613e6-fb71-4813-a449-c75e6cf27b8b",
        mapDataConverter: InventorySessionModel.fromJson,
      );
    });
    return Future.value(
      right(InventorySessionModel(sessionId: 123))
    );

    // return Future.value(
    //   left(
    //     InventorySessionConflictFailure(
    //       InventorySessionConflictModel(
    //         conflicts: const [
    //           InventorySessionConflictItemModel(
    //             productId: 1,
    //             expectedVersion: 2,
    //             currentVersion: 3,
    //             originalSystemQuantity: 50,
    //             currentSystemQuantity: 45,
    //             countedQuantity: 48,
    //           ),
    //           InventorySessionConflictItemModel(
    //             productId: 2,
    //             expectedVersion: 4,
    //             currentVersion: 5,
    //             originalSystemQuantity: 30,
    //             currentSystemQuantity: 35,
    //             countedQuantity: 32,
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
