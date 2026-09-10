class ApiResponseModel {
  dynamic data;
  int? count;
  bool? isSuccess;
  String? errorMessages;
  String? errorCode;
  ApiResponseModel({
    this.count,
    this.data,
    this.isSuccess,
    this.errorMessages,
    this.errorCode,
  });

  ApiResponseModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic> && json['error'] != null) {
      errorMessages = json['error']["message"];
      errorCode = json['error']["code"];
      isSuccess = false;
    } else {
      data = json;
      isSuccess = true;
    }
  }
}
