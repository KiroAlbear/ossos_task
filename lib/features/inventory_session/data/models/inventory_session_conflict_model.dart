class InventorySessionConflictItemModel {
  final int productId;
  final int expectedVersion;
  final int currentVersion;
  final int originalSystemQuantity;
  final int currentSystemQuantity;
  final int countedQuantity;

  const InventorySessionConflictItemModel({
    required this.productId,
    required this.expectedVersion,
    required this.currentVersion,
    required this.originalSystemQuantity,
    required this.currentSystemQuantity,
    required this.countedQuantity,
  });

  factory InventorySessionConflictItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return InventorySessionConflictItemModel(
      productId: json['productId'] as int,
      expectedVersion: json['expectedVersion'] as int,
      currentVersion: json['currentVersion'] as int,
      originalSystemQuantity: json['originalSystemQuantity'] as int,
      currentSystemQuantity: json['currentSystemQuantity'] as int,
      countedQuantity: json['countedQuantity'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'expectedVersion': expectedVersion,
    'currentVersion': currentVersion,
    'originalSystemQuantity': originalSystemQuantity,
    'currentSystemQuantity': currentSystemQuantity,
    'countedQuantity': countedQuantity,
  };
}

class InventorySessionConflictModel {
  final String status;
  final List<InventorySessionConflictItemModel> conflicts;

  InventorySessionConflictModel({
    required List<InventorySessionConflictItemModel> conflicts,
  }) : status = 'conflict',
       conflicts = List.unmodifiable(conflicts);

  factory InventorySessionConflictModel.fromJson(Map<String, dynamic> json) {
    if (json['status'] != 'conflict') {
      throw const FormatException('Expected an inventory session conflict.');
    }
    return InventorySessionConflictModel(
      conflicts: (json['conflicts'] as List<dynamic>)
          .map(
            (item) => InventorySessionConflictItemModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'conflicts': conflicts.map((item) => item.toJson()).toList(),
  };
}
