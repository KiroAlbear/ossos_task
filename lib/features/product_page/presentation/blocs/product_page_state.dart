import 'package:ossos_task/imports.dart';

enum ProductCountStatus { savedLocally, pendingSync, conflict, synced }

enum ProductCountFilter { all, counted, notCounted, conflicts }

class ProductPageState extends SuccessState {
  final ProductPageModel productPage;
  final List<ProductModel> filteredProducts;
  final String query;
  final ProductCountFilter filter;
  final bool isLoading;
  final String? errorMessage;
  final int countedCount;
  final int notCountedCount;
  final int conflictCount;

  ProductPageState({
    required this.productPage,
    List<ProductModel>? filteredProducts,
    this.query = '',
    this.filter = ProductCountFilter.all,
    this.isLoading = false,
    this.errorMessage,
    this.countedCount = 0,
    this.notCountedCount = 0,
    this.conflictCount = 0,
  }) : filteredProducts = List.unmodifiable(
         filteredProducts ?? productPage.data,
       );

  List<ProductModel> get products => productPage.data;
  int get page => productPage.page;
  int get totalPages => productPage.totalPages;
  bool get hasNextPage => productPage.hasNextPage;
}
