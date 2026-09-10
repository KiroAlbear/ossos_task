class TestFeatureModel {
  int number;
  TestFeatureModel({required this.number});

  // fromJson

  factory TestFeatureModel.fromJson(Map<String, dynamic> json) {
    return TestFeatureModel(number: json['number']);
  }
}
