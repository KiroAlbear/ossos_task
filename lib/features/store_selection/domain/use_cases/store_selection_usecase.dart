import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

class StoreSelectionUseCase
    extends UseCase<List<StoreSelectionModel>, NoParams> {
  final StoreSelectionRepository _repository;

  StoreSelectionUseCase(this._repository);

  @override
  Future<Either<Failure, List<StoreSelectionModel>>> call(NoParams params) {
    return _repository.fetchStores();
  }
}
