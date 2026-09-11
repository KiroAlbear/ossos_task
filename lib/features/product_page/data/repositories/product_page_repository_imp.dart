import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

class ProductPageRepositoryImp implements ProductPageRepository {
  final ProductPageRemoteDataSource _dataSource;

  ProductPageRepositoryImp(this._dataSource);

  @override
  Future<Either<Failure, ProductPageModel>> fetchProducts({
    required int page,
    int limit = 20,
  }) {
    return _dataSource.fetchProducts(page: page, limit: limit);
  }
}
