import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/core/utils/product_utils.dart';
import 'package:ossos_task/imports.dart';

import '../../data/models/inventory_session_request_model.dart';

class _ProductCountsResetEvent extends ProductPageEvent {
  const _ProductCountsResetEvent();
}

class ProductPageBloc extends Bloc<ProductPageEvent, BaseBlocState> {
  final ProductPageUseCase _useCase;
  final InventorySessionUseCase _submitUseCase;
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
  Map<int, int> _restoredCounts = <int, int>{};
  String? _restoreError;
  final _counts = <int, int>{};
  final _savedCounts = <int, int>{};
  Future<void> _saveQueue = Future<void>.value();
  String? _storageError;
  bool _submitting = false;

  ProductPageBloc(this._useCase, this._submitUseCase) : super(InitialState()) {
    on<_ProductCountsResetEvent>((event, emit) => _emitProducts(emit));
    on<RestoreProductCountsEvent>(_restoreCounts);
    on<ChangeProductCountEvent>(_changeProductCount);
    on<LoadProductsEvent>(_loadProducts);
    on<SubmitProductCountEvent>(_submitCount);
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
      _countedIds = Set<int>.of(event.countedIds);
      _statuses = Map<int, ProductCountStatus?>.of(event.statuses);
      _emitProducts(emit);
    });
  }

  Future<void> flushSaves() => _saveQueue;

  Future<void> _submitCount(
    SubmitProductCountEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    if (_submitting) return;
    _submitting = true;
    emit(ProductSubmissionLoadingState());
    try {

      await flushSaves();
      if (!allProductsCounted) {
        emit(
          ProductSubmissionErrorState(
            'Please count all products before submitting.',
          ),
        );
        return;
      }
      final storeKey = await ProductUtils().getStoreId() ?? '';
      // Preserve the existing Cairo demo draft key; its API store ID is 1.
      final storeId = storeKey == 'cairo' ? 1 : int.tryParse(storeKey);
      if (storeId == null || storeId <= 0) {
        emit(ProductSubmissionErrorState('Please select a valid store first.'));
        return;
      }
      await saveSubmittedProducts(storeKey);
      final items = _products.values
          .map(
            (product) => InventorySessionItemModel(
              productId: product.id,
              name: product.name,
              countedQuantity: _counts[product.id]!,
              expectedVersion: product.version,
            ),
          )
          .toList();

      final now = DateTime.now().toUtc();

      final request = InventorySessionRequestModel(
        clientSessionId: '$storeId-${now.microsecondsSinceEpoch}',
        storeId: storeId,
        createdAt: now,
        items: items,
      );
      final result = await _submitUseCase(
        InventorySessionParams(request: request),
      );
      if (emit.isDone) return;
      await result.fold<Future<void>>(
        (failure) async {
          if (failure is InventorySessionConflictFailure) {
            emit(
              ProductSubmissionConflictState(
                conflict: failure.conflict,
                request: request,
              ),
            );
          } else {
            emit(ProductSubmissionErrorState(failure.message));
          }
        },
        (session) async {
          await ProductUtils().deleteSubmittedProducts();
          await resetProductsData(storeKey);
          if (!emit.isDone) emit(ProductSubmissionSuccessState(session));
        },
      );
    } catch (_) {
      if (!emit.isDone) {
        emit(
          ProductSubmissionErrorState(
            'Unable to submit. Your local counts are retained. Please retry.',
          ),
        );
      }
    } finally {
      _submitting = false;
    }
  }

  bool get allProductsCounted =>
      !_restoring &&
      !_loading &&
      _page >= _totalPages &&
      _products.isNotEmpty &&
      (_products.length == (_totalItems ?? _products.length)) &&
      _products.keys.every((id) => (_counts[id] ?? -1) >= 0);

  /// Saves the completed count separately from the automatically saved draft.
  Future<void> saveSubmittedProducts(String storeId) async {
    await flushSaves();
    final items = _products.values
        .map(
          (product) => InventorySessionItemModel(
            name: product.name,
            productId: product.id,
            countedQuantity: _counts[product.id]!,
            expectedVersion: product.version,
          ).toJson(),
        )
        .toList();

    await ProductUtils().saveSubmittedProducts(items);
  }

  Future<List<InventorySessionItemModel>> getSavedCountedProducts(
    String storeId,
  ) async {
    return await ProductUtils().getSubmittedProducts();
  }

  /// Clears the draft after submission while keeping the submitted items.
  Future<void> resetProductsData(String storeId) async {
    await flushSaves();
    await SecureStorageManager.getInstance().deleteValue(
      'product_counts_$storeId',
    );
    _counts.clear();
    _savedCounts.clear();
    _restoredCounts.clear();
    _countedIds.clear();
    _statuses.clear();
    _storageError = null;
    _restoreError = null;
    _filter = ProductCountFilter.all;
    if (!isClosed) {
      final updated = stream.firstWhere(
        (state) => state is ProductPageState && state.productCountsMap.isEmpty,
      );
      add(const _ProductCountsResetEvent());
      await updated;
    }
  }

  Future<void> _restoreCounts(
    RestoreProductCountsEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    await ProductUtils().saveStoreId(event.storeId);
    _restoring = true;
    _restoreError = null;
    _restoredCounts.clear();
    _emitProducts(emit);
    try {
      _restoredCounts = await ProductUtils().getProductsSharedPrefrences();

      _counts
        ..clear()
        ..addAll(_restoredCounts);
      _savedCounts
        ..clear()
        ..addAll(_restoredCounts);
    } catch (_) {
      _restoreError = 'Could not restore locally saved counts.';
    } finally {
      if (!emit.isDone) {
        _restoring = false;
        _emitProducts(emit);
      }
    }
  }

  Future<void> _changeProductCount(
    ChangeProductCountEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    if (_submitting) return;
    final count = int.tryParse(event.value);
    if (count == null) {
      _counts.remove(event.productId);
    } else {
      _counts[event.productId] = count;
    }
    _storageError = null;
    _emitProducts(emit);
    // final snapshot = Map<int, int>.of(_counts);
    _saveQueue = _saveQueue.then((_) async {
      try {
        await ProductUtils().savePproductsSharedPrefrence(_counts);
        _savedCounts
          ..clear()
          ..addAll(_counts);
        _storageError = null;
      } catch (_) {
        _storageError = 'Could not save changes locally. Please retry.';
      }
    });
    await _saveQueue;
    if (!emit.isDone) _emitProducts(emit);
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
        counts: _counts,
        savedCounts: _savedCounts,
        storageError: _storageError,
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
      final total =
          _totalItems ?? (_page >= _totalPages ? _products.length : null);
      if (_error == null && total != null) {
        try {
          await SecureStorageManager.getInstance().setValue(
            SecureStorageKeys.productTotal,
            total.toString(),
          );
        } catch (_) {
          _storageError =
              'Could not save the product total locally. Please retry.';
          if (!emit.isDone) _emitProducts(emit);
        }
      }
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
