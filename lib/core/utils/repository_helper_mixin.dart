import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

mixin RepositoryHelperMixin {
  Future<Either<Failure, T>> apiCallWrapper<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      T data = await apiCall();
      return right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Something went wrong'));
    } on DataParsingException catch (e) {
      return Left(DataParsingFailure(e.message ?? 'Data has changed'));
    } on CustomException catch (e) {
      return Left(CustomFailure(e.message ?? 'Something went wrong'));
    } on NoConnectionException catch (e) {
      return Left(
        NoConnectionFailure(
          e.message ??
              'It seems that the server is not reachable at the moment',
        ),
      );
    }
  }
}
