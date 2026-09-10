import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

class StoreSelectionRepositoryImp implements StoreSelectionRepository {
  final StoreSelectionRemoteDataSource _dataSource;

  StoreSelectionRepositoryImp(this._dataSource);

  @override
  Future<Either<Failure, List<StoreSelectionModel>>> fetchStores() {
    return _dataSource.fetchStores();
  }
}
