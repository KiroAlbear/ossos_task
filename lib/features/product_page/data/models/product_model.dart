class ProductModel {
  final int id;
  final String name;
  final String sku;
  final String barcode;
  final int systemQuantity;
  final int version;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.systemQuantity,
    required this.version,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      sku: json['sku'] as String,
      barcode: json['barcode'] as String,
      systemQuantity: json['systemQuantity'] as int,
      version: json['version'] as int,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'sku': sku,
    'barcode': barcode,
    'systemQuantity': systemQuantity,
    'version': version,
    'updatedAt': updatedAt.toUtc().toIso8601String(),
  };
}
