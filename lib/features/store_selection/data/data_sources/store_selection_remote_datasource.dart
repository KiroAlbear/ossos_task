import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ossos_task/imports.dart';

abstract class StoreSelectionRemoteDataSource {
  Future<Either<Failure, List<StoreSelectionModel>>> fetchStores();
}

class StoreSelectionRemoteDataSourceImpl
    with ApiHelperMixin, RepositoryHelperMixin
    implements StoreSelectionRemoteDataSource {
  final String endpoint;

  StoreSelectionRemoteDataSourceImpl({required this.endpoint});

  @override
  Future<Either<Failure, List<StoreSelectionModel>>> fetchStores() {

      return apiCallWrapper<List<StoreSelectionModel>>(() {
        return fetchData<List<StoreSelectionModel>>(
          "https://mocki.io/v1/879eac91-5d8f-4ef2-b746-3daa509bf21e",
          dynamicDataConverter: (dynamic data) {
            return AppUtils.convertJsonList<StoreSelectionModel>(
              data,
              StoreSelectionModel.fromJson,
            );
          },
        );
      });

  }
}
