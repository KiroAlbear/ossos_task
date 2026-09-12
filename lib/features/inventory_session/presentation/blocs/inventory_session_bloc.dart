import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/core/base/base_bloc_state.dart';
import 'package:ossos_task/core/core.dart';

import '../../../../core/utils/product_utils.dart';
import '../../../product_page/data/data_sources/product_page_remote_datasource.dart';
import 'inventory_session_event.dart';
import 'inventory_session_state.dart';

class InventorySessionBloc extends Bloc<InventorySessionEvent, BaseBlocState> {
  InventorySessionBloc() : super(InitialState()) {
    on<getProductsCountEvent>(_getProductsCountProgress);
  }

  Future<void> _getProductsCountProgress(
    getProductsCountEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    try {
      emit(LoadingState());
      final products = await ProductUtils().getProductsSharedPrefrences();
      final result = await getIt<ProductPageRemoteDataSource>().fetchProducts(
        page: 1,
      );

      result.fold(
        (l) {
          emit(ErrorState(errorMessage: 'Total Products cannot be retrieved'));
        },
        (r) {
          final total = r.data.length;
          emit(ProductsProgressState(counted: products.length, total: total));
        },
      );
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
