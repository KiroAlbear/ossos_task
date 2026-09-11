import 'package:get_it/get_it.dart';
import 'package:ossos_task/core/services/urls.dart';
import 'package:ossos_task/features/inventory_session/inventory_session.dart';
import 'package:ossos_task/features/product_page/product_page.dart';
import 'package:ossos_task/features/store_selection/store_selection.dart';
import 'package:ossos_task/features/test_feature/test_feature.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  void init() {
    getIt.registerLazySingleton<InventorySessionRemoteDataSource>(
      () => InventorySessionRemoteDataSourceImpl(
        endpoint: Urls.submitInventorySession,
      ),
    );
    getIt.registerLazySingleton<InventorySessionRepository>(
      () => InventorySessionRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<InventorySessionUseCase>(
      () => InventorySessionUseCase(getIt()),
    );
    getIt.registerFactory<InventorySessionBloc>(
      () => InventorySessionBloc(getIt()),
    );
    getIt.registerLazySingleton<ProductPageRemoteDataSource>(
      () => ProductPageRemoteDataSourceImpl(),
    );
    getIt.registerLazySingleton<ProductPageRepository>(
      () => ProductPageRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<ProductPageUseCase>(
      () => ProductPageUseCase(getIt()),
    );
    getIt.registerFactory<ProductPageBloc>(() => ProductPageBloc(getIt()));
    getIt.registerLazySingleton<StoreSelectionRemoteDataSource>(
      () => StoreSelectionRemoteDataSourceImpl(),
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
