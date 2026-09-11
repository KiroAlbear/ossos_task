import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

abstract class ProductPageRepository {
  Future<Either<Failure, ProductPageModel>> fetchProducts({
    required int page,
    int limit = 20,
  });
}
