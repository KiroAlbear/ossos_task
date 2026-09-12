import 'package:ossos_task/core/base/base_bloc_state.dart';

class ProductsProgressState extends SuccessState {
  final int counted;
  final int? total;

  ProductsProgressState({required this.counted, required this.total});
}
