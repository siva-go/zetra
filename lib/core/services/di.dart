import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:zetra/core/api/api_client.dart';
import 'package:zetra/core/network/interceptors/auth_interceptor.dart';
import 'package:zetra/core/network/interceptors/logger_interceptor.dart';
import 'package:zetra/core/network/interceptors/token_interceptor.dart';
import 'package:zetra/core/storage/database/app_database.dart';
import 'package:zetra/core/storage/secure_storage.dart';
import 'package:zetra/features/authentication/bloc/auth_bloc.dart';
import 'package:zetra/features/charging/bloc/charging_bloc.dart';
import 'package:zetra/features/charging/bloc/charging_history_bloc.dart';
import 'package:zetra/features/charging/bloc/invoice_bloc.dart';
import 'package:zetra/features/charging/bloc/plugin_bloc.dart';
import 'package:zetra/features/charging/repository/charging_repository.dart';
import 'package:zetra/features/home/bloc/home_bloc.dart';
import 'package:zetra/features/notification/bloc/notification_bloc.dart';
import 'package:zetra/features/notification/repository/notification_repository.dart';
import 'package:zetra/features/profile/bloc/profile_bloc.dart';
import 'package:zetra/features/profile/repository/profile_repository.dart';
import 'package:zetra/features/station/bloc/scan_qr_bloc.dart';
import 'package:zetra/features/station/bloc/search_station_bloc.dart';
import 'package:zetra/features/station/bloc/station_detail_bloc.dart';
import 'package:zetra/features/wallet/bloc/wallet_bloc.dart';
import 'package:zetra/features/wallet/repository/invoice_repository.dart';
import 'package:zetra/features/wallet/repository/wallet_repository.dart';

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

  /// Repositories
  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepository(getIt<ApiClient>())
  );
  getIt.registerLazySingleton<InvoiceRepository>(
    () => InvoiceRepository(getIt<ApiClient>())
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(getIt<ApiClient>())
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(getIt<ApiClient>())
  );

  /// Blocs
  getIt.registerFactory<ChargingBloc>(
    () => ChargingBloc()
  );
  getIt.registerFactory<NotificationBloc>(
    () => NotificationBloc(getIt<NotificationRepository>())
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
  getIt.registerFactory<ScanQrBloc>(
    () => ScanQrBloc()
  );
  getIt.registerFactory<StationDetailBloc>(
    () => StationDetailBloc(getIt<ApiClient>())
  );
  getIt.registerLazySingleton<ChargingRepository>(
    () => ChargingRepository(getIt<ApiClient>())
  );
  getIt.registerFactory<ChargingHistoryBloc>(
    () => ChargingHistoryBloc(getIt<ChargingRepository>())
  );
  getIt.registerFactory<InvoiceBloc>(
    () => InvoiceBloc(getIt<InvoiceRepository>())
  );
  getIt.registerFactory<WalletBloc>(
    () => WalletBloc(getIt<WalletRepository>())
  );
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(getIt<ProfileRepository>())
  );

}