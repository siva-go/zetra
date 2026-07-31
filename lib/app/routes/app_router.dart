import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/core/storage/secure_storage.dart';
import 'package:zetra/features/authentication/views/login.dart';
import 'package:zetra/features/authentication/views/login_otp.dart';
import 'package:zetra/features/authentication/views/signup.dart';
import 'package:zetra/features/charging/bloc/charging_history_bloc.dart';
import 'package:zetra/features/charging/bloc/charging_history_event.dart';
import 'package:zetra/features/charging/views/charge_link.dart';
import 'package:zetra/features/charging/views/charging.dart' as charging;
import 'package:zetra/features/charging/views/charging_history_screen.dart';
import 'package:zetra/features/charging/views/invoice_screen.dart';
import 'package:zetra/features/charging/views/plug_in.dart';
import 'package:zetra/features/charging/views/plug_in_light.dart';
import 'package:zetra/features/home/views/notification_screen.dart';
import 'package:zetra/features/home/views/notification_screen_light.dart';
import 'package:zetra/features/home/views/profile_screen.dart';
import 'package:zetra/features/home/views/home.dart';
import 'package:zetra/features/station/bloc/scan_qr_bloc.dart';
import 'package:zetra/features/station/bloc/search_station_bloc.dart';
import 'package:zetra/features/station/bloc/search_station_event.dart';
import 'package:zetra/features/station/bloc/station_detail_bloc.dart';
import 'package:zetra/features/station/bloc/station_detail_event.dart';
import 'package:zetra/features/station/models/station_info.dart';
import 'package:zetra/features/station/views/scan_qr_screen.dart';
import 'package:zetra/features/station/views/search_station.dart';
import 'package:zetra/features/station/views/station_details.dart';
import 'package:zetra/features/wallet/bloc/wallet_bloc.dart';
import 'package:zetra/features/wallet/bloc/wallet_event.dart';
import 'package:zetra/features/wallet/views/add_money.dart';
import 'package:zetra/features/wallet/views/wallet.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (BuildContext context, GoRouterState state) async {

    final bool loggedIn = await GetIt.instance<SecureStorage>().hasAccessToken();
    final bool isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup' || state.matchedLocation == '/otp';

    if (!loggedIn && !isLoggingIn) {

      return '/login';

    }

    if (loggedIn && isLoggingIn) {

      return '/home';

    }

    return null;

  },
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {

        return const Login();

      }
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {

        return const SignUp();

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
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {

        return const Home();

      }
    ),
    GoRoute(
      path: '/notifications',
      builder: (BuildContext context, GoRouterState state) {

        return const NotificationScreen();

      }
    ),
    GoRoute(
      path: '/notifications-light',
      builder: (BuildContext context, GoRouterState state) {

        return const NotificationScreenLight();

      }
    ),
    GoRoute(
      path: '/plug-in',
      builder: (BuildContext context, GoRouterState state) {

        return const PlugInScreen();

      }
    ),
    GoRoute(
      path: '/plug-in-light',
      builder: (BuildContext context, GoRouterState state) {

        return const PlugInScreenLight();

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
    ),
    GoRoute(
      path: '/charging-history',
      builder: (BuildContext context, GoRouterState state) {

        return BlocProvider<ChargingHistoryBloc>(
          create: (_) => GetIt.instance<ChargingHistoryBloc>()..add(const LoadChargingHistory()),
          child: const ChargingHistoryScreen(),
        );

      }
    ),
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) {

        return const ProfileScreen();

      }
    ),
    GoRoute(
      path: '/invoice',
      builder: (BuildContext context, GoRouterState state) {

        return const InvoiceScreen();

      }
    ),
    GoRoute(
      path: '/scan-qr',
      builder: (BuildContext context, GoRouterState state) {

        return BlocProvider<ScanQrBloc>(
          create: (_) => GetIt.instance<ScanQrBloc>(),
          child: const ScanQrScreen()
        );

      }
    ),
    GoRoute(
      path: '/search-station',
      builder: (BuildContext context, GoRouterState state) {

        return BlocProvider<SearchStationBloc>(
          create: (_) => GetIt.instance<SearchStationBloc>()..add(FetchStations()),
          child: const SearchStation()
        );

      }
    ),
    GoRoute(
      path: '/station-details',
      builder: (BuildContext context, GoRouterState state) {

        final StationInfo? station = state.extra as StationInfo?;

        if (station == null) {

          return const Scaffold(
            body: Center(
              child: Text('Station not found')
            )
          );

        }

        return BlocProvider<StationDetailBloc>(
          create: (_) => GetIt.instance<StationDetailBloc>()..add(
            FetchStationDetail(
              stationId: station.id,
              userLat: station.latitude,
              userLng: station.longitude,
            ),
          ),
          child: StationDetails(station: station),
        );

      }
    ),
    GoRoute(
      path: '/wallet',
      builder: (BuildContext context, GoRouterState state) {

        return BlocProvider<WalletBloc>(
          create: (_) => GetIt.instance<WalletBloc>()..add(const WalletLoadRequested()),
          child: const Wallet(),
        );

      }
    ),
    GoRoute(
      path: '/wallet/add-money',
      builder: (BuildContext context, GoRouterState state) {

        return BlocProvider<WalletBloc>(
          create: (_) => GetIt.instance<WalletBloc>(),
          child: const AddMoney(),
        );

      }
    ),
  ]
);