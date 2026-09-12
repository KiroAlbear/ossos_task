import 'package:equatable/equatable.dart';

import '../../data/models/inventory_session_request_model.dart';

abstract class InventorySessionEvent extends Equatable {
  const InventorySessionEvent();

  @override
  List<Object> get props => [];
}

class SubmitInventorySessionEvent extends InventorySessionEvent {
  final InventorySessionRequestModel request;

  const SubmitInventorySessionEvent(this.request);

  @override
  List<Object> get props => [request];
}

class getProductsCountEvent extends InventorySessionEvent {


  const getProductsCountEvent();

  @override
  List<Object> get props => [];
}
