import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_response.freezed.dart';

@freezed
abstract class RemoteResponse<T> with _$RemoteResponse<T> {
  const RemoteResponse._();
  const factory RemoteResponse.noConnection() = _NoConnection;
  const factory RemoteResponse.failure(String message, bool success) = _Failure;
  const factory RemoteResponse.data(T data) = _Data<T>;
}
