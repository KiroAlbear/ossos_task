import 'package:equatable/equatable.dart';

abstract class InventorySessionEvent extends Equatable {
  const InventorySessionEvent();

  @override
  List<Object> get props => [];
}

class getProductsCountEvent extends InventorySessionEvent {
  const getProductsCountEvent();

  @override
  List<Object> get props => [];
}

class GetSubmittedProductsEvent extends InventorySessionEvent {
  const GetSubmittedProductsEvent();
}

class DeleteSubmittedProductsEvent extends InventorySessionEvent {
  const DeleteSubmittedProductsEvent();
}
