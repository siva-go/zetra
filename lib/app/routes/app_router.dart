import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/charging/presentation/screens/charge_link.dart';
import '../../features/charging/presentation/screens/charging.dart';
import '../../features/charging/presentation/screens/charging_history_screen.dart';
import '../../features/charging/presentation/screens/invoice_screen.dart';
import '../../features/charging/presentation/screens/plug_in.dart';
import '../../features/charging/presentation/screens/plug_in_light.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/notification_screen.dart';
import '../../features/home/presentation/screens/notification_screen_light.dart';
import '../../features/home/presentation/screens/profile_screen.dart';

/// AppRouter defines the GoRouter routing configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const ZetraHomeScreen();
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
        return const HomeScreen();
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
  ],
);
