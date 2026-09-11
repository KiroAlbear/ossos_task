import 'package:ossos_task/imports.dart';

class ProductPageState extends SuccessState {
  final ProductPageModel productPage;

  ProductPageState({required this.productPage});

  List<ProductModel> get products => productPage.data;
  int get page => productPage.page;
  int get totalPages => productPage.totalPages;
  bool get hasNextPage => productPage.hasNextPage;
}
