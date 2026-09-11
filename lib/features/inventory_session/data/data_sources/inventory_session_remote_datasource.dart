import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ossos_task/imports.dart';

import '../../domain/failures/inventory_session_conflict_failure.dart';
import '../models/inventory_session_conflict_model.dart';
import '../models/inventory_session_model.dart';
import '../models/inventory_session_request_model.dart';

abstract class InventorySessionRemoteDataSource {
  Future<Either<Failure, InventorySessionModel>> submitInventorySession(
    InventorySessionRequestModel request,
  );
}

class InventorySessionRemoteDataSourceImpl
    with ApiHelperMixin, RepositoryHelperMixin
    implements InventorySessionRemoteDataSource {
  /// The backend submission URL must be supplied when wiring this feature.
  final String endpoint;
  final bool authorizedApi;

  InventorySessionRemoteDataSourceImpl({
    required this.endpoint,
    this.authorizedApi = false,
  });

  @override
  Future<Either<Failure, InventorySessionModel>> submitInventorySession(
    InventorySessionRequestModel request,
  ) async {
    // Use the shared transport directly: postData discards non-200 payloads,
    // including the version/quantity details returned with HTTP 409.
    try {
      final response = await ApiService.getInstance().post(
        endpoint,
        body: request.toJson(),
        authorizedApi: authorizedApi,
      );
      return _parseResponse(response);
    } on DioException catch (error) {
      if (error.response != null) {
        return _parseResponse(error.response!);
      }
      switch (error.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const Left(
            NoConnectionFailure('Unable to reach the server. Please retry.'),
          );
        default:
          return const Left(
            ServerFailure('Unable to submit the inventory session.'),
          );
      }
    }
  }

  Either<Failure, InventorySessionModel> _parseResponse(
    Response<dynamic> response,
  ) {
    final code = response.statusCode ?? 0;
    if (code != 409 && (code < 200 || code >= 300)) {
      return Left(
        ServerFailure('Inventory session submission failed (HTTP $code).'),
      );
    }
    try {
      final data = response.data;
      final json =
          (data is String ? jsonDecode(data) : data) as Map<String, dynamic>;
      if (json['status'] == 'conflict') {
        return Left(
          InventorySessionConflictFailure(
            InventorySessionConflictModel.fromJson(json),
          ),
        );
      }
      if (code == 409) {
        return const Left(
          DataParsingFailure('Invalid inventory session conflict response.'),
        );
      }
      return Right(InventorySessionModel.fromJson(json));
    } on FormatException {
      return const Left(
        DataParsingFailure('Invalid inventory session response.'),
      );
    } on TypeError {
      return const Left(
        DataParsingFailure('Invalid inventory session response.'),
      );
    }
  }
}
