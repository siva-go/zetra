import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/features/authentication/views/login.dart';
import 'package:zetra/features/authentication/views/login_otp.dart';
import 'package:zetra/features/charging/presentation/screens/charge_link.dart';
import 'package:zetra/features/charging/presentation/screens/charging.dart' as charging;
import 'package:zetra/features/home/views/home.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {

        return const Home();

      }
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {

        return const Login();

      }
    ),
    GoRoute(
      path: '/otp',
      builder: (BuildContext context, GoRouterState state) {

        final String phone = state.uri.queryParameters['phone'] ?? '';
        return LoginOtp(
            phone: phone
        );

      }
    ),
    GoRoute(
      path: '/charge-link',
      builder: (BuildContext context, GoRouterState state) {

        return const ChargeLinkScreen();

      }
    ),
    GoRoute(
      path: '/charging',
      builder: (BuildContext context, GoRouterState state) {

        return const charging.HomeScreen();

      }
    )
  ]
);