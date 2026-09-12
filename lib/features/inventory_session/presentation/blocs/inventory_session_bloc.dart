import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/core/base/base_bloc_state.dart';
import 'package:ossos_task/core/core.dart';

import '../../../../core/utils/product_utils.dart';
import '../../../product_page/data/data_sources/product_page_remote_datasource.dart';
import '../../../product_page/data/models/inventory_session_request_model.dart';
import 'inventory_session_event.dart';
import 'inventory_session_state.dart';

class InventorySessionBloc extends Bloc<InventorySessionEvent, BaseBlocState> {
  int _counted = 0;
  int? _total;
  List<InventorySessionItemModel> _submittedProducts = [];
  bool _isLoadingSubmittedProducts = false;
  bool _isDeletingSubmittedProducts = false;
  int _submittedProductsRevision = 0;
  String? _submittedProductsError;
  bool _isLoadingProgress = false;
  String? _progressError;

  InventorySessionBloc() : super(InitialState()) {
    on<getProductsCountEvent>(_getProductsCountProgress);
    on<GetSubmittedProductsEvent>(_getSubmittedProducts);
    on<DeleteSubmittedProductsEvent>(_deleteSubmittedProducts);
  }

  void _emitState(Emitter<BaseBlocState> emit) {
    if (emit.isDone) return;
    emit(
      ProductsProgressState(
        counted: _counted,
        total: _total,
        submittedProducts: _submittedProducts,
        isLoadingSubmittedProducts: _isLoadingSubmittedProducts,
        isDeletingSubmittedProducts: _isDeletingSubmittedProducts,
        submittedProductsError: _submittedProductsError,
        isLoadingProgress: _isLoadingProgress,
        progressError: _progressError,
      ),
    );
  }

  Future<void> _getSubmittedProducts(
    GetSubmittedProductsEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    if (_isLoadingSubmittedProducts || _isDeletingSubmittedProducts) return;
    final revision = _submittedProductsRevision;
    _isLoadingSubmittedProducts = true;
    _submittedProductsError = null;
    _emitState(emit);
    try {
      final products = await ProductUtils().getSubmittedProducts();
      if (revision == _submittedProductsRevision) _submittedProducts = products;
    } catch (_) {
      if (revision == _submittedProductsRevision) {
        _submittedProductsError = 'Could not load locally submitted products.';
      }
    } finally {
      _isLoadingSubmittedProducts = false;
      _emitState(emit);
    }
  }

  Future<void> _deleteSubmittedProducts(
    DeleteSubmittedProductsEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    if (_isDeletingSubmittedProducts) return;
    _isDeletingSubmittedProducts = true;
    _submittedProductsRevision++;
    _submittedProductsError = null;
    _emitState(emit);
    try {
      await ProductUtils().deleteSubmittedProducts();
      _submittedProducts = [];
    } catch (_) {
      _submittedProductsError =
          'Could not delete submitted products. Please retry.';
    } finally {
      _isDeletingSubmittedProducts = false;
      _emitState(emit);
    }
  }

  Future<void> _getProductsCountProgress(
    getProductsCountEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    if (_isLoadingProgress) return;
    // Refresh pending sync on entry and when returning from product counting.
    add(const GetSubmittedProductsEvent());
    _isLoadingProgress = true;
    _progressError = null;
    _emitState(emit);
    try {
      final products = await ProductUtils().getProductsSharedPrefrences();
      final result = await getIt<ProductPageRemoteDataSource>().fetchProducts(
        page: 1,
      );

      result.fold(
        (l) {
          _progressError = 'Total Products cannot be retrieved';
        },
        (r) {
          _counted = products.length;
          _total = r.totalItems ?? r.data.length;
        },
      );
    } catch (_) {
      _progressError = 'Could not load locally saved product counts.';
    } finally {
      _isLoadingProgress = false;
      _emitState(emit);
    }
  }
}
