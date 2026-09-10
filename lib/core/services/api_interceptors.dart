import 'package:dio/dio.dart';
import 'package:ossos_task/core/services/secure_storage/secure_storage_keys.dart';
import 'package:ossos_task/imports.dart';
// import '../index.dart';

class ApiInterceptors extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.headers.containsKey("Authorization") &&
        options.headers["Authorization"]) {
      options.headers.remove("Authorization");
      String? token = await SecureStorageManager.getInstance().getValue(
        SecureStorageKeys.userToken,
      );
      Logger.log(token ?? "TOKEN NOT FOUND");
      options.headers['Authorization'] = 'Bearer $token';
      return handler.next(options);
    }
    return handler.next(options);
  }

  @override
  Future<dynamic> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Logger.log(err.response?.statusCode.toString());
    Logger.logTrace("APISERVICE ON ERROR", err.error, err.stackTrace);
    return handler.reject(err);
  }

  @override
  Future<dynamic> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    return handler.next(response);
  }
}
