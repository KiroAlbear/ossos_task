import 'package:get_it/get_it.dart';
import 'package:ossos_task/imports.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    /////////////////////////////////// regions ///////////////////////////////////////////////////
    getIt.registerSingleton<RegionRemoteDataSource>(
      RegionRemoteDataSourceImpl(),
    );
    getIt.registerSingleton<RegionRepository>(RegionRepositoryImp(getIt()));
    getIt.registerSingleton<RegionUseCase>(RegionUseCase(getIt()));
    getIt.registerSingleton<RegionBloc>(RegionBloc(getIt()));

    /////////////////////////////////// registration ///////////////////////////////////////////////////
    getIt.registerSingleton<RegistrationRemoteDataSource>(
      RegistrationRemoteDataSourceImpl(),
    );
    getIt.registerSingleton<RegistrationRepository>(
      RegistrationRepositoryImp(getIt()),
    );
    getIt.registerSingleton<RegistrationUseCase>(RegistrationUseCase(getIt()));
    getIt.registerSingleton<RegistrationBloc>(RegistrationBloc(getIt()));

    /////////////////////////////////// login ///////////////////////////////////////////////////
    getIt.registerSingleton<LoginRemoteDataSource>(LoginRemoteDataSourceImpl());
    getIt.registerSingleton<LoginRepository>(LoginRepositoryImp(getIt()));
    getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt()));
    getIt.registerSingleton<LoginBloc>(LoginBloc(getIt()));

    /////////////////////////////////// otp ///////////////////////////////////////////////////
    getIt.registerSingleton<OtpRemoteDataSource>(OtpRemoteDataSourceImpl());
    getIt.registerSingleton<OtpRepository>(OtpRepositoryImp(getIt()));
    getIt.registerSingleton<VerifyEmailOtpUseCase>(
      VerifyEmailOtpUseCase(getIt()),
    );
    getIt.registerSingleton<VerifyPhoneOtpUseCase>(
      VerifyPhoneOtpUseCase(getIt()),
    );
    getIt.registerSingleton<ResendEmailOtpUseCase>(
      ResendEmailOtpUseCase(getIt()),
    );
    getIt.registerSingleton<ResendPhoneOtpUseCase>(
      ResendPhoneOtpUseCase(getIt()),
    );
    getIt.registerFactory<OtpBloc>( () =>
      OtpBloc(getIt(), getIt(), getIt(), getIt()),
    );
  }
}
