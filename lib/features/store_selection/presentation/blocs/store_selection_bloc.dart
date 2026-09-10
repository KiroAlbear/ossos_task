import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/imports.dart';

class StoreSelectionBloc extends Bloc<StoreSelectionEvent, BaseBlocState> {
  final StoreSelectionUseCase _useCase;

  StoreSelectionBloc(this._useCase) : super(InitialState()) {
    on<LoadStoresEvent>(_loadStores);
    on<SelectStoreEvent>(_selectStore);
  }

  Future<void> _loadStores(
    LoadStoresEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    if (state is LoadingState) return;
    emit(LoadingState());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(ErrorState(errorMessage: failure.message)),
      (stores) => emit(StoreSelectionState(stores: stores)),
    );
  }

  void _selectStore(SelectStoreEvent event, Emitter<BaseBlocState> emit) {
    final current = state;
    if (current is! StoreSelectionState) return;
    for (final store in current.stores) {
      if (store.id == event.storeId) {
        emit(StoreSelectionState(stores: current.stores, selectedStore: store));
        return;
      }
    }
  }
}
