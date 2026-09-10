import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

abstract class TestFeatureRemoteDataSource {
  Future<Either<Failure, TestFeatureModel>> getMyFeature();
}

class TestFeatureRemoteDataSourceImpl
    with ApiHelperMixin, RepositoryHelperMixin
    implements TestFeatureRemoteDataSource {
  @override
  Future<Either<Failure, TestFeatureModel>> getMyFeature() async {
    Logger.log("getMyFeature is called");
    return await apiCallWrapper<TestFeatureModel>(() {
      return fetchData<TestFeatureModel>(
        "exampleURL",
        mapDataConverter: TestFeatureModel.fromJson,
      );
    });
  }
}
