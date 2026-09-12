
class InventorySessionRequestModel {
  final String clientSessionId;
  final int storeId;
  final DateTime createdAt;
  final List<InventorySessionItemModel> items;

  InventorySessionRequestModel({
    required this.clientSessionId,
    required this.storeId,
    required this.createdAt,
    required List<InventorySessionItemModel> items,
  }) : items = List.unmodifiable(items);

  factory InventorySessionRequestModel.fromJson(Map<String, dynamic> json) {
    return InventorySessionRequestModel(
      clientSessionId: json['clientSessionId'] as String,
      storeId: json['storeId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      items: (json['items'] as List<dynamic>)
          .map(
            (item) => InventorySessionItemModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'clientSessionId': clientSessionId,
    'storeId': storeId,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'items': items.map((item) => item.toJson()).toList(),
  };
}

class InventorySessionItemModel {
  final int productId;
  final String name;
  final int countedQuantity;
  final int expectedVersion;

  const InventorySessionItemModel({
    required this.productId,
    required this.name,
    required this.countedQuantity,
    required this.expectedVersion,
  });

  factory InventorySessionItemModel.fromJson(Map<String, dynamic> json) {
    return InventorySessionItemModel(
      productId: json['productId'] as int,
      name: json['name'] as String,
      countedQuantity: json['countedQuantity'] as int,
      expectedVersion: json['expectedVersion'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'countedQuantity': countedQuantity,
    'expectedVersion': expectedVersion,
  };
}

