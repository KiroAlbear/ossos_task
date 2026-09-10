import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

abstract class StoreSelectionRepository {
  Future<Either<Failure, List<StoreSelectionModel>>> fetchStores();
}
