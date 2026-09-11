class InventorySessionModel {
  final int sessionId;
  final String status;

  const InventorySessionModel({required this.sessionId}) : status = 'accepted';

  factory InventorySessionModel.fromJson(Map<String, dynamic> json) {
    if (json['status'] != 'accepted') {
      throw const FormatException('Expected an accepted inventory session.');
    }
    return InventorySessionModel(sessionId: json['sessionId'] as int);
  }

  Map<String, dynamic> toJson() => {'sessionId': sessionId, 'status': status};
}
