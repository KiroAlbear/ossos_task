import 'package:equatable/equatable.dart';

abstract class StoreSelectionEvent extends Equatable {
  const StoreSelectionEvent();

  @override
  List<Object> get props => [];
}

class LoadStoresEvent extends StoreSelectionEvent {
  const LoadStoresEvent();
}

class SelectStoreEvent extends StoreSelectionEvent {
  final int storeId;

  const SelectStoreEvent(this.storeId);

  @override
  List<Object> get props => [storeId];
}
