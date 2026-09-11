import 'package:ossos_task/imports.dart';

class ProductPageModel {
  final List<ProductModel> data;
  final int page;
  final int totalPages;

  ProductPageModel({
    required List<ProductModel> data,
    required this.page,
    required this.totalPages,
  }) : data = List.unmodifiable(data);

  bool get hasNextPage => page < totalPages;

  factory ProductPageModel.fromJson(Map<String, dynamic> json) {
    return ProductPageModel(
      data: (json['data'] as List<dynamic>)
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((product) => product.toJson()).toList(),
    'page': page,
    'totalPages': totalPages,
  };
}
