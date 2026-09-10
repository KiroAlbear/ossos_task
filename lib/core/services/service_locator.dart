import 'package:get_it/get_it.dart';
import 'package:ossos_task/core/services/urls.dart';
import 'package:ossos_task/features/store_selection/store_selection.dart';
import 'package:ossos_task/features/test_feature/test_feature.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  void init()  {
    getIt.registerLazySingleton<StoreSelectionRemoteDataSource>(
      () => StoreSelectionRemoteDataSourceImpl(endpoint: Urls.getStores),
    );
    getIt.registerLazySingleton<StoreSelectionRepository>(
      () => StoreSelectionRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<StoreSelectionUseCase>(
      () => StoreSelectionUseCase(getIt()),
    );
    // getIt.registerFactory<StoreSelectionBloc>(
    //   () => StoreSelectionBloc(getIt()),
    // );
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
