import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/core/base/base_bloc_state.dart';
import 'package:ossos_task/core/core.dart';
import 'package:ossos_task/core/services/secure_storage/secure_storage_keys.dart';
import 'package:ossos_task/core/services/secure_storage/secure_storage_manager.dart';
import 'package:ossos_task/features/product_page/domain/use_cases/product_page_usecase.dart';

import '../../../product_page/data/data_sources/product_page_remote_datasource.dart';
import '../../domain/failures/inventory_session_conflict_failure.dart';
import '../../domain/use_cases/inventory_session_usecase.dart';
import 'inventory_session_event.dart';
import 'inventory_session_state.dart';

class InventorySessionBloc extends Bloc<InventorySessionEvent, BaseBlocState> {
  final InventorySessionUseCase _useCase;
  bool _submitting = false;

  InventorySessionBloc(this._useCase) : super(InitialState()) {
    on<SubmitInventorySessionEvent>(_submitInventorySession);
    on<getProductsCountEvent>(_getProductsCountProgress);
  }

  /// Reads saved product counts for a store and the cached catalog total.
  /// A null total means the full catalog size has not been saved yet.
  Future<int> getProductCountProgressSharedPrefrences(
    String storeId,
  ) async {
    final storage = SecureStorageManager.getInstance();
    final values = await Future.wait([
      storage.getValue('product_counts_$storeId'),
      storage.getValue(SecureStorageKeys.productTotal),
    ]);
    final counts = values[0] == null
        ? <String, dynamic>{}
        : jsonDecode(values[0]!) as Map<String, dynamic>;
    final counted = counts.entries
        .where(
          (entry) =>
              int.tryParse(entry.key) != null &&
              entry.value is int &&
              (entry.value as int) >= 0,
        )
        .map((entry) => int.parse(entry.key))
        .toSet()
        .length;

    return counted;
  }

  Future<void> _submitInventorySession(
    SubmitInventorySessionEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    if (_submitting) return;
    _submitting = true;
    emit(LoadingState());
    try {
      final result = await _useCase(
        InventorySessionParams(request: event.request),
      );
      if (emit.isDone) return;
      result.fold((failure) {
        if (failure is InventorySessionConflictFailure) {
          emit(
            InventorySessionConflictState(
              conflict: failure.conflict,
              request: event.request,
            ),
          );
        } else {
          emit(ErrorState(errorMessage: failure.message));
        }
      }, (session) => emit(InventorySessionState(session: session)));
    } catch (_) {
      if (!emit.isDone) {
        emit(
          ErrorState(
            errorMessage:
                'Unable to submit the inventory session. Please retry.',
          ),
        );
      }
    } finally {
      _submitting = false;
    }
  }

  Future<void> _getProductsCountProgress(
    getProductsCountEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    try {

      emit(LoadingState());
      final products = await getIt<ProductPageUseCase>().getProductsSharedPrefrences(event.storeId);
      final result = await getIt<ProductPageRemoteDataSource>().fetchProducts(page:1);

      result.fold((l) {
        emit(
          ErrorState(
            errorMessage: 'Total Products cannot be retrieved',
          ),
        );
      }, (r) {
        final total = r.data.length;
        emit(ProductsProgressState(counted: products.length, total: total));
      },);

    } catch (e) {
      if (!emit.isDone) {
        emit(
          ErrorState(
            errorMessage: 'Could not load locally saved product counts.',
          ),
        );
      }
    }
  }
}
