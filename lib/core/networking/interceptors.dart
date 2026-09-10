import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final modifiedOptions = options
      ..headers.addAll(
        {
                 'accept': 'application/json'
        },
      );
    handler.next(modifiedOptions);
  }
}
