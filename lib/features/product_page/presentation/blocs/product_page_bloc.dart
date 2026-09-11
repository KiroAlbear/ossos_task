import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/imports.dart';

class ProductPageBloc extends Bloc<ProductPageEvent, BaseBlocState> {
  final ProductPageUseCase _useCase;
  final _products = <int, ProductModel>{};
  Set<int> _countedIds = {};
  Map<int, ProductCountStatus?> _statuses = {};
  String _query = '';
  ProductCountFilter _filter = ProductCountFilter.all;
  int _page = 0;
  int _totalPages = 1;
  int? _totalItems;
  int _limit = 10;
  bool _loading = false;
  String? _error;
  bool _restoring = true;
  final _restoredCounts = <int, int>{};
  String? _restoreError;

  ProductPageBloc(this._useCase) : super(InitialState()) {
    on<RestoreProductCountsEvent>(_restoreCounts);
    on<LoadProductsEvent>(_loadProducts);
    on<SearchProductsEvent>((event, emit) {
      _query = event.query;
      _emitProducts(emit);
      _loadRemainingForFilter();
    });
    on<FilterProductsEvent>((event, emit) {
      _filter = event.filter;
      _emitProducts(emit);
      _loadRemainingForFilter();
    });
    on<UpdateProductCountFiltersEvent>((event, emit) {
      _countedIds = event.countedIds;
      _statuses = event.statuses;
      _emitProducts(emit);
    });
  }

  Future<void> _restoreCounts(
    RestoreProductCountsEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    _restoring = true;
    _restoreError = null;
    _restoredCounts.clear();
    _emitProducts(emit);
    try {
      final raw = await SecureStorageManager.getInstance().getValue(
        'product_counts_${event.storeId}',
      );
      if (emit.isDone) return;
      if (raw != null) {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        for (final entry in data.entries) {
          final id = int.tryParse(entry.key);
          if (id != null && entry.value is int && (entry.value as int) >= 0) {
            _restoredCounts[id] = entry.value as int;
          }
        }
      }
    } catch (_) {
      _restoreError = 'Could not restore locally saved counts.';
    } finally {
      if (!emit.isDone) {
        _restoring = false;
        _emitProducts(emit);
      }
    }
  }

  void _loadRemainingForFilter() {
    if (!_loading &&
        _error == null &&
        _page < _totalPages &&
        (_query.trim().isNotEmpty || _filter != ProductCountFilter.all)) {
      add(LoadProductsEvent(page: _page + 1, limit: _limit));
    }
  }

  void _emitProducts(Emitter<BaseBlocState> emit) {
    final query = _query.trim().toLowerCase();
    final filtered = _products.values.where((product) {
      final matches =
          query.isEmpty ||
          '${product.name} ${product.sku} ${product.barcode}'
              .toLowerCase()
              .contains(query);
      return matches &&
          switch (_filter) {
            ProductCountFilter.all => true,
            ProductCountFilter.counted => _countedIds.contains(product.id),
            ProductCountFilter.notCounted => !_countedIds.contains(product.id),
            ProductCountFilter.conflicts =>
              _statuses[product.id] == ProductCountStatus.conflict,
          };
    }).toList();
    final total =
        _totalItems ?? (_page >= _totalPages ? _products.length : null);
    emit(
      ProductPageState(
        productPage: ProductPageModel(
          data: _products.values.toList(),
          page: _page,
          totalPages: _totalPages,
          totalItems: total,
        ),
        filteredProducts: filtered,
        query: _query,
        filter: _filter,
        isLoading: _loading,
        errorMessage: _error,
        countedCount: _countedIds.length,
        notCountedCount: total == null
            ? _products.keys.where((id) => !_countedIds.contains(id)).length
            : (total - _countedIds.length).clamp(0, total),
        conflictCount: _products.keys
            .where((id) => _statuses[id] == ProductCountStatus.conflict)
            .length,
        isRestoring: _restoring,
        restoredCounts: _restoredCounts,
        restoreError: _restoreError,
      ),
    );
  }

  Future<void> _loadProducts(
    LoadProductsEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    if (_loading) return;
    // Ignore duplicate or out-of-order requests queued by scrolling/filtering.
    if (event.page != 1 && (event.page != _page + 1 || _page >= _totalPages)) {
      return;
    }
    _loading = true;
    _error = null;
    _limit = event.limit;
    if (_products.isEmpty) {
      emit(LoadingState());
    } else {
      _emitProducts(emit);
    }
    try {
      final result = await _useCase(
        ProductPageParams(page: event.page, limit: event.limit),
      );
      if (emit.isDone) return;
      _loading = false;
      result.fold(
        (failure) {
          _error = failure.message;
          if (_products.isEmpty) {
            emit(ErrorState(errorMessage: _error));
          } else {
            _emitProducts(emit);
          }
        },
        (productPage) {
          if (event.page == 1) _products.clear();
          for (final product in productPage.data) {
            _products[product.id] = product;
          }
          _page = productPage.page;
          _totalPages = productPage.totalPages;
          _totalItems = productPage.totalItems;
          _emitProducts(emit);
          _loadRemainingForFilter();
        },
      );
    } catch (_) {
      if (emit.isDone) return;
      _loading = false;
      _error = 'Unable to load products. Please try again.';
      if (_products.isEmpty) {
        emit(ErrorState(errorMessage: _error));
      } else {
        _emitProducts(emit);
      }
    }
  }
}
