import 'failure.dart';

class ErrorObject {
  final String? message;
  final String? code;

  const ErrorObject({required this.message, this.code});

  static ErrorObject mapFailureToGenericErrorModel(Failure failure) {
    return ErrorObject(message: failure.message);
  }

  factory ErrorObject.fromJson(Map<String, dynamic> json) {
    return ErrorObject(message: json['message'], code: json['code']);
  }
}
