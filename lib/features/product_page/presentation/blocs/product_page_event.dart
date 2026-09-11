import 'package:equatable/equatable.dart';

import 'product_page_state.dart';

abstract class ProductPageEvent extends Equatable {
  const ProductPageEvent();

  @override
  List<Object> get props => [];
}

class RestoreProductCountsEvent extends ProductPageEvent {
  final String storeId;

  const RestoreProductCountsEvent(this.storeId);

  @override
  List<Object> get props => [storeId];
}

class ChangeProductCountEvent extends ProductPageEvent {
  final String storeId;
  final int productId;
  final String value;

  const ChangeProductCountEvent({
    required this.storeId,
    required this.productId,
    required this.value,
  });

  @override
  List<Object> get props => [storeId, productId, value];
}

class SearchProductsEvent extends ProductPageEvent {
  final String query;
  const SearchProductsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FilterProductsEvent extends ProductPageEvent {
  final ProductCountFilter filter;
  const FilterProductsEvent(this.filter);

  @override
  List<Object> get props => [filter];
}

class UpdateProductCountFiltersEvent extends ProductPageEvent {
  final Set<int> countedIds;
  final Map<int, ProductCountStatus?> statuses;

  UpdateProductCountFiltersEvent({
    required Set<int> countedIds,
    required Map<int, ProductCountStatus?> statuses,
  }) : countedIds = Set.unmodifiable(countedIds),
       statuses = Map.unmodifiable(statuses);

  @override
  List<Object> get props => [countedIds, statuses];
}

class LoadProductsEvent extends ProductPageEvent {
  final int page;
  final int limit;

  const LoadProductsEvent({this.page = 1, this.limit = 20});

  @override
  List<Object> get props => [page, limit];
}
