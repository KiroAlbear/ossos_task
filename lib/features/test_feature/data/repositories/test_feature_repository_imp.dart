import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

class TestFeatureRepositoryImp implements TestFeatureRepository {
  final TestFeatureRemoteDataSource _dataSource;
  TestFeatureRepositoryImp(this._dataSource);

  @override
  Future<Either<Failure, TestFeatureModel>> getMyTestFeature() async {
    return _dataSource.getMyFeature();
  }
}
