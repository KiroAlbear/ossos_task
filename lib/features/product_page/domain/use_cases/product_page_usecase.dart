import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

class ProductPageUseCase extends UseCase<ProductPageModel, ProductPageParams> {
  final ProductPageRepository _repository;

  ProductPageUseCase(this._repository);

  @override
  Future<Either<Failure, ProductPageModel>> call(ProductPageParams params) {
    if (params.page < 1) {
      return Future.value(
        const Left(CustomFailure('Page must be greater than zero.')),
      );
    }
    if (params.limit < 1) {
      return Future.value(
        const Left(CustomFailure('Limit must be greater than zero.')),
      );
    }
    return _repository.fetchProducts(page: params.page, limit: params.limit);
  }
}




class ProductPageParams {
  final int page;
  final int limit;

  const ProductPageParams({this.page = 1, this.limit = 20});
}
