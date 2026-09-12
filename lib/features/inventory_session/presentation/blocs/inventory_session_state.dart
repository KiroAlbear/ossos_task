import 'package:ossos_task/core/base/base_bloc_state.dart';

import '../../../product_page/data/models/inventory_session_request_model.dart';

class ProductsProgressState extends SuccessState {
  final int counted;
  final int? total;
  final List<InventorySessionItemModel> submittedProducts;
  final bool isLoadingSubmittedProducts;
  final String? submittedProductsError;
  final bool isLoadingProgress;
  final String? progressError;

  bool get hasSubmittedProducts => submittedProducts.isNotEmpty;

  ProductsProgressState({
    required this.counted,
    required this.total,
    List<InventorySessionItemModel> submittedProducts = const [],
    this.isLoadingSubmittedProducts = false,
    this.submittedProductsError,
    this.isLoadingProgress = false,
    this.progressError,
  }) : submittedProducts = List.unmodifiable(submittedProducts);
}
