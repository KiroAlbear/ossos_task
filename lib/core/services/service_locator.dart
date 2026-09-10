import 'package:get_it/get_it.dart';
import 'package:ossos_task/features/test_feature/test_feature.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    getIt.registerLazySingleton<TestFeatureRemoteDataSource>(
      TestFeatureRemoteDataSourceImpl.new,
    );
    getIt.registerLazySingleton<TestFeatureRepository>(
      () => TestFeatureRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<TestFeatureUseCase>(
      () => TestFeatureUseCase(getIt()),
    );
    getIt.registerFactory<TestFeatureBloc>(TestFeatureBloc.new);
  }
}
