import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/features/authentication/views/login.dart';
import 'package:zetra/features/authentication/views/login_otp.dart';
import 'package:zetra/features/charging/presentation/screens/charge_link.dart';
import 'package:zetra/features/charging/presentation/screens/charging.dart' as charging;
import 'package:zetra/features/charging/presentation/screens/charging_history_screen.dart';
import 'package:zetra/features/charging/presentation/screens/invoice_screen.dart';
import 'package:zetra/features/charging/presentation/screens/plug_in.dart';
import 'package:zetra/features/charging/presentation/screens/plug_in_light.dart';
import 'package:zetra/features/home/views/home.dart';
import 'package:zetra/features/home/presentation/screens/notification_screen.dart';
import 'package:zetra/features/home/presentation/screens/notification_screen_light.dart';
import 'package:zetra/features/home/presentation/screens/profile_screen.dart';
import 'package:zetra/features/station/bloc/search_station_bloc.dart';
import 'package:zetra/features/station/models/station_info.dart';
import 'package:zetra/features/station/views/search_station.dart';
import 'package:zetra/features/station/views/station_details.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const Login();
      },
    ),
    GoRoute(
      path: '/otp',
      builder: (BuildContext context, GoRouterState state) {
        final String phone = state.uri.queryParameters['phone'] ?? '';
        return LoginOtp(phone: phone);
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const Home();
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (BuildContext context, GoRouterState state) {
        return const NotificationScreen();
      },
    ),
    GoRoute(
      path: '/notifications-light',
      builder: (BuildContext context, GoRouterState state) {
        return const NotificationScreenLight();
      },
    ),
    GoRoute(
      path: '/plug-in',
      builder: (BuildContext context, GoRouterState state) {
        return const PlugInScreen();
      },
    ),
    GoRoute(
      path: '/plug-in-light',
      builder: (BuildContext context, GoRouterState state) {
        return const PlugInScreenLight();
      },
    ),
    GoRoute(
      path: '/charge-link',
      builder: (BuildContext context, GoRouterState state) {
        return const ChargeLinkScreen();
      },
    ),
    GoRoute(
      path: '/charging',
      builder: (BuildContext context, GoRouterState state) {
        return const charging.HomeScreen();
      },
    ),
    GoRoute(
      path: '/charging-history',
      builder: (BuildContext context, GoRouterState state) {
        return const ChargingHistoryScreen();
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileScreen();
      },
    ),
    GoRoute(
      path: '/invoice',
      builder: (BuildContext context, GoRouterState state) {
        return const InvoiceScreen();
      },
    ),
    GoRoute(
      path: '/search-station',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider<SearchStationBloc>(
          create: (_) => SearchStationBloc(),
          child: const SearchStation(),
        );
      },
    ),
    GoRoute(
      path: '/station-details',
      builder: (BuildContext context, GoRouterState state) {
        final StationInfo? station = state.extra as StationInfo?;
        if (station == null) {
          return const Scaffold(
            body: Center(
              child: Text('Station not found'),
            ),
          );
        }
        return StationDetails(station: station);
      },
    ),
  ],
);
