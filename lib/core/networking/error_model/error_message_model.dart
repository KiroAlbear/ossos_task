// // class ErrorMessageModel extends Equatable {
// //   final String message;
// //   final int status;
// //
// //   const ErrorMessageModel({required this.message, required this.status});
// //
// //   factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
// //     return ErrorMessageModel(
// //       message: json['message'],
// //       status: json['Status'],
// //     );
// //   }
// //
// //   @override
// //   List<Object> get props => [message, status];
// // }
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:ossos_task/core/utils/helpers/enums.dart';
//
// part 'error_message_model.freezed.dart';
// part 'error_message_model.g.dart';
//
// @freezed
// abstract class ErrorMessageModel with _$ErrorMessageModel {
//   const factory ErrorMessageModel({
//     @JsonKey(name: 'status_code') int? status_code,
//     @JsonKey(name: 'status_message') required String status_message,
//     @JsonKey(name: 'success') required bool success,
//     required PageStates errorType,
//   }) = _ErrorMessageModel;
//
//   factory ErrorMessageModel.fromJson(Map<String, dynamic> json) =>
//       _$ErrorMessageModelFromJson(json);
// }
