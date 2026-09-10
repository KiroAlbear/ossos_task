import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ossos_task/imports.dart';

mixin ApiHelperMixin {
  Future<T> fetchData<T>(
    String path, {
    bool authorizedApi = false,
    Object? body,
    ApiResponseModel Function(Map<String, dynamic>)? customResponseModel,
    T Function(Map<String, dynamic>)? mapDataConverter,
    T Function(dynamic)? dynamicDataConverter,
  }) async {
    try {
      T convertedResult;
      final Response<dynamic> response;

      response = await ApiService.getInstance().get(
        path,
        authorizedApi: authorizedApi,
        body: body,
      );

      convertedResult = handleStatusCode(
        response: response,
        customResponseModel: customResponseModel,
        mapDataConverter: mapDataConverter,
        dynamicDataConverter: dynamicDataConverter,
      );
      return convertedResult;
    } catch (e) {
      Exception exception = exceptionHandler(e as Exception);
      throw exception;
    }
  }

  Future<T> postData<T>(
    String path, {
    bool authorizedApi = false,
    ApiResponseModel Function(Map<String, dynamic>)? customResponseModel,
    Map<String, dynamic>? body,
    FormData? formDataBody,
    T Function(Map<String, dynamic>)? mapDataConverter,
    T Function(dynamic)? dynamicDataConverter,
  }) async {
    try {
      T convertedResult;
      final Response<dynamic> response;

      response = await ApiService.getInstance().post(
        path,
        body: body,
        authorizedApi: authorizedApi,
        formDataBody: formDataBody,
      );

      convertedResult = handleStatusCode(
        response: response,
        customResponseModel: customResponseModel,
        mapDataConverter: mapDataConverter,
        dynamicDataConverter: dynamicDataConverter,
      );
      return convertedResult;
    } catch (e) {
      Exception exception = exceptionHandler(e as Exception);
      throw exception;
    }
  }
}

dynamic handleStatusCode({
  required Response<dynamic> response,
  ApiResponseModel Function(Map<String, dynamic>)? customResponseModel,
  Function(Map<String, dynamic>)? mapDataConverter,
  Function(dynamic)? dynamicDataConverter,
}) {
  if (response.statusCode == 200) {
    dynamic convertedResult;
    ApiResponseModel apiResponse;
    apiResponse = handleApiResponseModel(response, customResponseModel);
    convertedResult = dataConverter(
      result: apiResponse,
      mapDataConverter: mapDataConverter,
      dynamicDataConverter: dynamicDataConverter,
    );
    return convertedResult;
  } else {
    throw ServerException();
  }
}

ApiResponseModel handleApiResponseModel(
  Response<dynamic> response,
  ApiResponseModel Function(Map<String, dynamic>)? customResponseModel,
) {
  ApiResponseModel apiResponse;
  try {
    final dynamic decodedJson = json.decode(response.data);
    if (customResponseModel == null) {
      apiResponse = ApiResponseModel.fromJson(decodedJson);
    } else {
      apiResponse = customResponseModel(decodedJson);
    }

    if (apiResponse.isSuccess == false) {
      throw CustomException(message: apiResponse.errorMessages);
    }
  } catch (e) {
    throw DataParsingException();
  }
  return apiResponse;
}

Exception exceptionHandler(Exception e) {
  if (e is DioException) {
    // this error is for server error (bad request, timeout, etc...)
    if (e.type.index != 6) {
      Map<String, dynamic> error = json.decode(e.response.toString());
      return ServerException(message: error["error"]["message"]);
    } else {
      // this error is for no internet connection
      return NoConnectionException(); //here
    }
  }

  if ((e is ServerException) ||
      (e is CustomException) ||
      (e is DataParsingException)) {
    return e;
  } else {
    return NoConnectionException();

    ///here the default
  }
}

dynamic dataConverter({
  required ApiResponseModel result,
  Function(dynamic)? dynamicDataConverter,
  Function(Map<String, dynamic>)? mapDataConverter,
}) {
  dynamic convertedResult;
  try {
    if (mapDataConverter != null) {
      convertedResult = mapDataConverter(result.data);
    } else if (dynamicDataConverter != null) {
      convertedResult = dynamicDataConverter(result.data);
    } else {
      throw MissingDataConversionFunctionException();
    }
  } catch (e) {
    throw DataConversionException();
  }
  return convertedResult;
}
