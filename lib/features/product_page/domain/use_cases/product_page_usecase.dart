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

  Future<Map<int,int>> getProductsSharedPrefrences(String storeId) async {
    final Map<int,int> _restoredCounts = {};
    final raw = await SecureStorageManager.getInstance().getValue(
      'product_counts_${storeId}',
    );

    if (raw != null) {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in data.entries) {
        final id = int.tryParse(entry.key);
        if (id != null && entry.value is int && (entry.value as int) >= 0) {
          _restoredCounts[id] = entry.value as int;
        }
      }
    }
    return _restoredCounts;
  }
}




class ProductPageParams {
  final int page;
  final int limit;

  const ProductPageParams({this.page = 1, this.limit = 20});
}
