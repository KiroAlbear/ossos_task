import 'package:equatable/equatable.dart';

abstract class ProductPageEvent extends Equatable {
  const ProductPageEvent();

  @override
  List<Object> get props => [];
}

class LoadProductsEvent extends ProductPageEvent {
  final int page;
  final int limit;

  const LoadProductsEvent({this.page = 1, this.limit = 20});

  @override
  List<Object> get props => [page, limit];
}
