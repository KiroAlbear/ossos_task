import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/imports.dart';

class ProductPageBloc extends Bloc<ProductPageEvent, BaseBlocState> {
  final ProductPageUseCase _useCase;


  ProductPageBloc(this._useCase) : super(InitialState()) {
    on<LoadProductsEvent>(_loadProducts);
  }

  Future<void> _loadProducts(
    LoadProductsEvent event,
    Emitter<BaseBlocState> emit,
  ) async {

    emit(LoadingState());
    final result = await _useCase(
      ProductPageParams(page: event.page, limit: event.limit),
    );

    if (emit.isDone) return;
    result.fold(
      (failure) => emit(ErrorState(errorMessage: failure.message)),
      (productPage) => emit(ProductPageState(productPage: productPage)),
    );
  }
}
