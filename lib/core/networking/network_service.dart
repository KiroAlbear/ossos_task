// ignore_for_file: avoid_catches_without_on_clauses, cast_nullable_to_non_nullable

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ossos_task/core/networking/remote_response.dart';

import 'interceptors.dart';

/// A Base Remote Service for all the app.
///
/// Has all the methods needed to comunicate with the server.
///
/// Handles [Error]s and [Exception]s respectfully.
///
/// Returns a sailed union of type [RemoteResponse] that contains:
///  * [RemoteResponse.data]
///  * [RemoteResponse.failure]
///  * [RemoteResponse.noConnection]
class RemoteService {
  final Dio _dio;

  RemoteService(this._dio) {
    _dio
      ..options.connectTimeout = Duration(milliseconds: 1000)
      ..options.headers.addAll({'Accept': 'application/json'})
      ..options.responseType = ResponseType.plain
      ..interceptors.add(AuthInterceptor())
      ..options.validateStatus = (int? statusCode) =>
          statusCode == 200 || statusCode == 400;
  }

  /// Perform a POST request.
  Future<RemoteResponse<dynamic>> dioPost(
    String api,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    if (body != null) debugPrint("API Body:\n${body}");
    if (queryParameters != null) debugPrint("API Query Paramaters:\n${api}");
    try {
      final response = await _dio.post(
        api,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      final dynamic responseData = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Info log");
        debugPrint("Post Method Info");
        debugPrint("Response: ${responseData}");
        return RemoteResponse.data(responseData);
      } else if (response.statusCode == 400) {
        debugPrint("Error log");
        debugPrint("Post Method Error");
        debugPrint("Post Method Status Code: ${response.statusCode}");
        debugPrint("Error: ${responseData['status_message']}");
        return RemoteResponse.failure(
          responseData['errors'][0],
          responseData['isSuccess'],
        );
      } else {
        debugPrint("Error log");
        debugPrint("Post Method Error");
        debugPrint("Post Method Status Code: ${response.statusCode}");
        debugPrint("Error: ${responseData['status_message']}");
        return RemoteResponse.failure(
          responseData['errors'][0],
          responseData['isSuccess'],
        );
      }
    } on DioException catch (e) {
      debugPrint("Error log");
      debugPrint("Post Method Error");
      debugPrint("Error: ${e.message}");
      if (e.isNoInternet) {
        return const RemoteResponse.noConnection();
      } else {
        return RemoteResponse.failure(e.message!, false);
      }
    }
  }

  /// Perform a GET request.
  Future<RemoteResponse<dynamic>> dioGet(
    String api, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    debugPrint("Debug log");
    debugPrint("Get Method Call");
    debugPrint("API URL: ${api}");
    if (queryParameters != null) debugPrint("API Query Paramaters:\n${api}");
    try {
      final response = await _dio.get(
        api,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      final dynamic responseData = jsonDecode(response.data);
      if (response.statusCode == 200) {
        debugPrint("Info log");
        debugPrint("Get Method Info");
        debugPrint("Response:\n${responseData}");
        return RemoteResponse.data(responseData);
      } else if (response.statusCode == 400) {
        debugPrint("Error log");
        debugPrint("Get Method Error");
        debugPrint("Get Method Status Code: ${response.statusCode}");
        debugPrint("Error: ${responseData['status_message']}");
        return RemoteResponse.failure(
          responseData['errors'][0],
          responseData['isSuccess'],
        );
      } else {
        debugPrint("Error log");
        debugPrint("Get Method Error");
        debugPrint("Get Method Status Code: ${response.statusCode}");
        debugPrint("Error: ${responseData['status_message']}");
        return RemoteResponse.failure(
          responseData['errors'][0],
          responseData['isSuccess'],
        );
      }
    } on DioException catch (e) {
      debugPrint("Error log");
      debugPrint("Get Method Error");
      debugPrint("Error: ${e.message}");
      if (e.isNoInternet) {
        return const RemoteResponse.noConnection();
      } else {
        return RemoteResponse.failure(e.message!, false);
      }
    }
  }
}

extension NoInternet on DioException {
  /// Returns `true` if the error is [SocketException].
  bool get isNoInternet =>
      type == DioExceptionType.unknown && error is SocketException;
}
