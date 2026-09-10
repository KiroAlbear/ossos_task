import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

abstract class TestFeatureRepository {
  Future<Either<Failure, TestFeatureModel>> getMyTestFeature();
}
