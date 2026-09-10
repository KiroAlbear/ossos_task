import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

class TestFeatureUseCase extends UseCase<TestFeatureModel, TestFeatureParams> {
  final TestFeatureRepository _repository;

  TestFeatureUseCase(this._repository);

  @override
  Future<Either<Failure, TestFeatureModel>> call(TestFeatureParams params) {
    return _repository.getMyTestFeature();
  }
}

class TestFeatureParams {
  final int number;
  TestFeatureParams(this.number);
}
