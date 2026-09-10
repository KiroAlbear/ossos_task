class StoreSelectionModel {
  final int id;
  final String name;

  const StoreSelectionModel({required this.id, required this.name});

  factory StoreSelectionModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    if (id is! int || name is! String) {
      throw const FormatException(
        'A store must have an integer id and a name.',
      );
    }
    return StoreSelectionModel(id: id, name: name);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
