import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zetra/app/routes/app_router.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/core/services/di.dart';
import 'package:zetra/features/authentication/bloc/auth_bloc.dart';
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

    ScreenUtil.init(context);

    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<ChargingBloc>(
          create: (_) => getIt<ChargingBloc>()
        ),
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>()
        )
      ],
      child: MaterialApp.router(
        title: 'ZETRA EV Charging',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: AppColors.scaffoldLight,
          cardColor: AppColors.cardLight,
          textTheme: GoogleFonts.urbanistTextTheme(ThemeData.light().textTheme)
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.scaffoldDark,
          cardColor: AppColors.cardDark,
          textTheme: GoogleFonts.urbanistTextTheme(ThemeData.dark().textTheme)
        ),
        routerConfig: appRouter
      )
    );

  }

}