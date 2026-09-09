import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zetra/app/routes/app_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/core/l10n/app_localizations.dart';
import 'package:zetra/core/services/di.dart';
import 'package:zetra/features/authentication/bloc/auth_bloc.dart';
import 'package:zetra/features/charging/bloc/charging_bloc.dart';
import 'package:zetra/features/charging/bloc/charging_history_bloc.dart';
import 'package:zetra/features/charging/bloc/invoice_bloc.dart';
import 'package:zetra/features/charging/bloc/plugin_bloc.dart';
import 'package:zetra/features/home/bloc/home_bloc.dart';
import 'package:zetra/features/notification/bloc/notification_bloc.dart';
import 'package:zetra/features/profile/bloc/profile_bloc.dart';
import 'package:zetra/features/wallet/bloc/wallet_bloc.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.navBackground,
      systemNavigationBarIconBrightness: Brightness.light
    )
  );

  await setupDependencies();

  runApp(const ZetraApp());

}

class ZetraApp extends StatelessWidget {
  const ZetraApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>()
        ),
        BlocProvider<ChargingBloc>(
          create: (_) => getIt<ChargingBloc>()
        ),
        BlocProvider<HomeBloc>(
          create: (_) => getIt<HomeBloc>()
        ),
        BlocProvider<PlugInBloc>(
          create: (_) => getIt<PlugInBloc>()
        ),
        BlocProvider<ChargingHistoryBloc>(
          create: (_) => getIt<ChargingHistoryBloc>()
        ),
        BlocProvider<WalletBloc>(
          create: (_) => getIt<WalletBloc>()
        ),
        BlocProvider<NotificationBloc>(
          create: (_) => getIt<NotificationBloc>()
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => getIt<ProfileBloc>()
        ),
        BlocProvider<InvoiceBloc>(
          create: (_) => getIt<InvoiceBloc>()
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {

          return MaterialApp.router(
            title: 'ZETRA EV Charging',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              scaffoldBackgroundColor: AppColors.scaffoldLight,
              colorScheme: const ColorScheme.light(
                primary: AppColors.primary,
                surface: AppColors.scaffoldLight
              )
            ),
            darkTheme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: AppColors.scaffoldDark,
              colorScheme: const ColorScheme.dark(
                primary: AppColors.primary,
                surface: AppColors.scaffoldDark
              )
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: appRouter
          );

        }
      )
    );

  }

}