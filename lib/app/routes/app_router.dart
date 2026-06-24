import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/charging/presentation/screens/charge_link.dart';
import '../../features/charging/presentation/screens/charging.dart';

/// AppRouter defines the GoRouter routing configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: '/charge-link',
  routes: [
    GoRoute(
      path: '/charge-link',
      builder: (BuildContext context, GoRouterState state) {
        return const ChargeLinkScreen();
      },
    ),
    GoRoute(
      path: '/charging',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
  ],
);
