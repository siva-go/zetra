import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:zetra/core/api/api_client.dart';
import 'package:zetra/core/network/interceptors/auth_interceptor.dart';
import 'package:zetra/core/network/interceptors/logger_interceptor.dart';
import 'package:zetra/core/network/interceptors/token_interceptor.dart';
import 'package:zetra/core/storage/database/app_database.dart';
import 'package:zetra/core/storage/secure_storage.dart';
import 'package:zetra/features/authentication/bloc/auth_bloc.dart';
import 'package:zetra/features/charging/presentation/bloc/charging_bloc.dart';
import 'package:zetra/features/home/bloc/home_bloc.dart';
import 'package:zetra/features/charging/presentation/bloc/plugin_bloc.dart';
import 'package:zetra/features/station/bloc/search_station_bloc.dart';

final GetIt getIt = GetIt.instance;

/// Registers all application dependencies.
Future<void> setupDependencies() async {

  await ScreenUtil.ensureScreenSize();

  /// Storage
  getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  /// Network Interceptors
  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(
        secureStorage: getIt<SecureStorage>()
    )
  );
  getIt.registerLazySingleton<LoggerInterceptor>(
    () => const LoggerInterceptor()
  );

  getIt.registerLazySingleton<ApiClient>(
    () {
      final TokenInterceptor tokenInterceptor = TokenInterceptor(
        secureStorage: getIt<SecureStorage>(),
      );
      final ApiClient client = ApiClient(
        authInterceptor: getIt<AuthInterceptor>(),
        tokenInterceptor: tokenInterceptor,
        loggerInterceptor: getIt<LoggerInterceptor>(),
      );
      tokenInterceptor.dio = client.dio;
      return client;
    }
  );

  /// Blocs
  getIt.registerFactory<ChargingBloc>(
    () => ChargingBloc()
  );
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      getIt<ApiClient>(),
      getIt<SecureStorage>(),
    )
  );
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc()
  );
  getIt.registerFactory<PlugInBloc>(
    () => PlugInBloc()
  );
  getIt.registerFactory<SearchStationBloc>(
    () => SearchStationBloc(getIt<ApiClient>())
  );

}