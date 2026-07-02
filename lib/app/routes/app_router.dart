import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zetra/features/authentication/views/login.dart';
import 'package:zetra/features/authentication/views/login_otp.dart';
import 'package:zetra/features/charging/presentation/screens/charge_link.dart';
import 'package:zetra/features/charging/presentation/screens/charging.dart' as charging;
import 'package:zetra/features/home/views/home.dart';
import 'package:zetra/features/station/bloc/search_station_bloc.dart';
import 'package:zetra/features/station/models/station_info.dart';
import 'package:zetra/features/station/views/search_station.dart';
import 'package:zetra/features/station/views/station_details.dart';
import 'package:zetra/features/station/bloc/scan_qr_bloc.dart';
import 'package:zetra/features/station/views/scan_qr_screen.dart';
import 'package:zetra/features/wallet/bloc/wallet_bloc.dart';
import 'package:zetra/features/wallet/views/add_money_screen.dart';
import 'package:zetra/features/wallet/views/wallet_screen.dart';

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
      ),
      GoRoute(
          path: '/search-station',
          builder: (BuildContext context, GoRouterState state) {

            return BlocProvider<SearchStationBloc>(
                create: (_) => SearchStationBloc(),
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

          return StationDetails(
              station: station
          );

        }

      ),
      GoRoute(
        path: '/scan-qr',
        builder: (BuildContext context, GoRouterState state) {

          return BlocProvider<ScanQrBloc>(
            create: (_) => ScanQrBloc(),
            child: const ScanQrScreen(),
          );

        },
      ),
      GoRoute(
        path: '/wallet',
        builder: (BuildContext context, GoRouterState state) {

          return BlocProvider<WalletBloc>(
            create: (_) => WalletBloc(),
            child: const WalletScreen(),
          );

        },
        routes: <RouteBase>[
          GoRoute(
            path: 'add-money',
            builder: (BuildContext context, GoRouterState state) {

              // Inherits the WalletBloc from the parent shell via context
              return const AddMoneyScreen();

            },
          ),
        ],
      ),
    ]
);