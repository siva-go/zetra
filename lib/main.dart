import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/app/routes/app_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/core/services/di.dart';
import 'package:zetra/features/charging/presentation/bloc/charging_bloc.dart';

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

    return BlocProvider<ChargingBloc>(
      create: (_) => getIt<ChargingBloc>(),
      child: MaterialApp.router(
        title: 'ZETRA EV Charging',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.scaffoldDark
        ),
        routerConfig: appRouter
      )
    );

  }

}