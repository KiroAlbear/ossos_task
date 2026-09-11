import 'package:equatable/equatable.dart';

import 'product_page_state.dart';

abstract class ProductPageEvent extends Equatable {
  const ProductPageEvent();

  @override
  List<Object> get props => [];
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
