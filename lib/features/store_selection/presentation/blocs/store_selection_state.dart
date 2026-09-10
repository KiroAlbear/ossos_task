import 'package:ossos_task/imports.dart';

class StoreSelectionState extends SuccessState {
  final List<StoreSelectionModel> stores;
  final StoreSelectionModel? selectedStore;

  StoreSelectionState({
    required List<StoreSelectionModel> stores,
    this.selectedStore,
  }) : stores = List.unmodifiable(stores);
}
