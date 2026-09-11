import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

abstract class StoreSelectionRemoteDataSource {
  Future<Either<Failure, List<StoreSelectionModel>>> fetchStores();
}

class StoreSelectionRemoteDataSourceImpl
    with ApiHelperMixin, RepositoryHelperMixin
    implements StoreSelectionRemoteDataSource {

  StoreSelectionRemoteDataSourceImpl();

  @override
  Future<Either<Failure, List<StoreSelectionModel>>> fetchStores() {

      final List<StoreSelectionModel> storeList = [
        StoreSelectionModel(id: 1, name: 'Cairo Store'),
        StoreSelectionModel(id: 2, name: 'Alexandria Store'),
      ];

      Future.delayed(Duration(seconds: 1));
      return Future.value(Right(storeList));

  }
}
