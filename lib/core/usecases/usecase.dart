import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
