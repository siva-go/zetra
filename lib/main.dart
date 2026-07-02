import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/app/routes/app_router.dart';
import 'package:zetra/features/charging/presentation/bloc/charging_bloc.dart';
import 'package:zetra/features/charging/presentation/bloc/plugin_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D1120),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ZetraApp());
}

class ZetraApp extends StatelessWidget {
  const ZetraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChargingBloc()),
        BlocProvider(create: (context) => PlugInBloc()),
      ],
      child: MaterialApp.router(
        title: 'ZETRA EV Charging',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0A0E17),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
