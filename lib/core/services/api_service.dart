import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:ossos_task/imports.dart';

class ApiService {
  static Dio dio = Dio();
  static ApiService? _instance;

  static ApiService getInstance() {
    if (_instance == null) {
      BaseOptions options = BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      );
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
      dio.options = options;
      dio.interceptors.add(ApiInterceptors());
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          enabled: kDebugMode,
        ),
      );
      _instance = ApiService();
    }
    return _instance!;
  }

  Future<Response<dynamic>> get(
    String uri, {
    bool authorizedApi = false,
    Object? body,
  }) async {
    Map<String, Object> headers = _getHeaders(authorizedApi);
    Logger.log(uri);
    try {
      Response<dynamic> res = await dio.get(
        uri,
        data: body,
        options: Options(
          headers: headers,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          responseType: ResponseType.plain,
        ),
      );

      return res;
    } catch (ex) {
      rethrow;
    }
  }

  Future<Response<dynamic>> post(
    String uri, {
    bool authorizedApi = false,
    Map<String, dynamic>? body,
    FormData? formDataBody,
  }) async {
    Map<String, Object> headers = _getHeaders(authorizedApi);
    try {
      Object? data = body ?? formDataBody;
      Response<dynamic> res = await dio.post(
        uri,
        data: data,
        options: Options(
          headers: headers,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          responseType: ResponseType.plain,
        ),
      );
      Logger.log(res.statusCode.toString());
      return res;
    } catch (ex) {
      rethrow;
    }
  }

  Map<String, Object> _getHeaders(bool isAuthorizedApi) {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      // 'AgentType': Platform.isAndroid ? 2 : 1,
      // 'Authorization': isAuthorizedApi
    };
    return headers;
  }

  // static Future<File?> getImageFromNetwork(String imageUrl,
  //     {bool authorizedApi = false}) async {
  //   try {
  //     final file = await DefaultCacheManager().getSingleFile(imageUrl);
  //     return file;
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
