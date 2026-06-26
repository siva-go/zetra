import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zetra/app/themes/app_colors.dart';
import 'package:zetra/app/themes/app_radius.dart';
import 'package:zetra/app/themes/app_typography.dart';
import 'package:zetra/core/widgets/bottom_nav_bar.dart';
import 'package:zetra/features/home/bloc/home_bloc.dart';
import 'package:zetra/features/home/bloc/home_event.dart';
import 'package:zetra/features/home/bloc/home_state.dart';
import 'package:zetra/features/home/widgets/nearest_station_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  static const List<_CityMarker> _markers = <_CityMarker>[
    _CityMarker('Chandigarh', 30.7333, 76.7794, false),
    _CityMarker('Delhi', 28.6139, 77.2090, false),
    _CityMarker('Lucknow', 26.8467, 80.9462, false),
    _CityMarker('Kolkata', 22.5726, 88.3639, false),
    _CityMarker('Ahmedabad', 23.0225, 72.5714, false),
    _CityMarker('Indore', 22.7196, 75.8577, false),
    _CityMarker('Bhopal', 23.2599, 77.4126, false),
    _CityMarker('Nagpur', 21.1458, 79.0882, false),
    _CityMarker('Mumbai', 19.0760, 72.8777, true),   // highlighted nearest
    _CityMarker('Hyderabad', 17.3850, 78.4867, false),
    _CityMarker('Bengaluru', 12.9716, 77.5946, false),
    _CityMarker('Chennai', 13.0827, 80.2707, false)
  ];

  @override
  void initState() {

    super.initState();
    context.read<HomeBloc>().add(HomeInitialized());

  }

  @override
  void dispose() {

    _searchController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? AppColors.navBackground : AppColors.whiteColor,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark
      )
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, HomeState state) {

          return Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: _buildMapSection(isDark, state)
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        bottom: false,
                        child: Column(
                          children: <Widget>[
                            _buildTopBar(isDark),
                            SizedBox(
                                height: 8.h
                            ),
                            _buildSearchBar(isDark)
                          ]
                        )
                      )
                    ),
                    if (state.showNearestStation && state.nearestStation != null)
                      Positioned(
                        bottom: 12.h,
                        left: 16.w,
                        right: 16.w,
                        child: NearestStationCard(
                          station: state.nearestStation!,
                          isDark: isDark,
                          onDismiss: () {

                            context.read<HomeBloc>().add(NearestStationDismissed());

                          },
                          onScanQr: () {

                            HapticFeedback.mediumImpact();
                            // TODO: navigate to scan QR screen

                          }
                        )
                      ),
                    if (!state.showNearestStation)
                      Positioned(
                        bottom: 20.h,
                        right: 16.w,
                        child: _buildLocateButton(isDark)
                      )
                    else
                      Positioned(
                        bottom: 228.h,
                        right: 16.w,
                        child: _buildLocateButton(isDark)
                      )
                  ]
                )
              ),
              ZetraBottomNavBar(
                currentIndex: state.currentNavIndex,
                onTap: (int idx) {

                  context.read<HomeBloc>().add(NavigationTabChanged(idx));

                }
              )
            ]
          );

        }
      )
    );

  }

  Widget _buildTopBar(bool isDark) {

    final Color textPrimary = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.h
      ),
      child: Row(
        children: <Widget>[
          ShaderMask(
            shaderCallback: (Rect bounds) => const LinearGradient(
              colors: <Color>[Color(0xFF00C853), Color(0xFF2EFE58)]
            ).createShader(bounds),
            child: Text(
              'ZETRA',
              style: AppTypography.h3.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
                color: AppColors.whiteColor,
                height: 1
              )
            )
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: AppRadius.mdBorder,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h
                  ),
                  decoration: BoxDecoration(
                    color: cardBg.withValues(
                        alpha: isDark ? 0.9 : 0.95
                    ),
                    borderRadius: AppRadius.mdBorder,
                    border: Border.all(
                        color: borderColor
                    )
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Wallet',
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 8.sp,
                              color: textSecondary,
                              letterSpacing: 0.5
                            )
                          ),
                          Text(
                            '₹ 600.00',
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 12.sp,
                              color: textPrimary,
                              fontWeight: FontWeight.w700
                            )
                          )
                        ]
                      ),
                      SizedBox(
                          width: 6.w
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(
                              alpha: 0.15
                          ),
                          borderRadius: AppRadius.smBorder
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: AppColors.primary,
                          size: 16
                        )
                      )
                    ]
                  )
                )
              )
            )
          )
        ]
      )
    ).animate().fade(
        duration: 500.ms
    ).slideY(
      begin: -0.1,
      curve: Curves.easeOutCubic
    );

  }

  Widget _buildSearchBar(bool isDark) {

    final Color cardBg = isDark ? AppColors.cardDark : AppColors.whiteColor;
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color textSecondary = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final Color hintColor = isDark ? AppColors.textHint : AppColors.textHintLight;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 16.w
      ),
      child: ClipRRect(
        borderRadius: AppRadius.roundBorder,
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 12,
              sigmaY: 12
          ),
          child: Container(
            decoration: BoxDecoration(
              color: cardBg.withValues(
                  alpha: isDark ? 0.88 : 0.92
              ),
              borderRadius: AppRadius.roundBorder,
              border: Border.all(
                  color: borderColor
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.blackColor.withValues(
                    alpha: isDark ? 0.25 : 0.08
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4)
                )
              ]
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                    width: 14.w
                ),
                Icon(
                  Icons.search_rounded,
                  color: textSecondary,
                  size: 20
                ),
                SizedBox(
                    width: 8.w
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (String val) {

                      context.read<HomeBloc>().add(SearchQueryChanged(val));

                    },
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 13.sp,
                      color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search location or station',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        fontSize: 13.sp,
                        color: hintColor
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 13.h
                      )
                    )
                  )
                ),
                Container(
                  margin: EdgeInsets.only(
                      right: 10.w
                  ),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    borderRadius: AppRadius.smBorder
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: textSecondary,
                    size: 17
                  )
                )
              ]
            )
          )
        )
      )
    ).animate().fade(
        delay: 100.ms,
        duration: 500.ms
    ).slideY(
      begin: -0.1,
      curve: Curves.easeOutCubic
    );

  }

  Widget _buildMapSection(bool isDark, HomeState state) {

    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(20.5937, 78.9629), // Center of India
        zoom: 4.8
      ),
      style: isDark ? _darkMapStyle : _lightMapStyle,
      onMapCreated: (GoogleMapController controller) {

        _mapController = controller;

      },
      markers: _markers.map((_CityMarker marker) {

        return Marker(
          markerId: MarkerId(marker.city),
          position: LatLng(marker.latitude, marker.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            marker.highlighted ? BitmapDescriptor.hueCyan : BitmapDescriptor.hueGreen
          ),
          infoWindow: InfoWindow(title: marker.city),
          onTap: () {

            if (marker.highlighted) {

              context.read<HomeBloc>().add(NearestStationShown());

            }

          }

        );
      }).toSet(),
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false
    );

  }

  Widget _buildLocateButton(bool isDark) {

    return GestureDetector(
      onTap: () {

        HapticFeedback.lightImpact();
        context.read<HomeBloc>().add(LocationRequested());
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            const CameraPosition(
              target: LatLng(19.0760, 72.8777), // Mumbai highlighted station
              zoom: 12
            )
          )
        );

      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppColors.cardDark : AppColors.whiteColor,
          border: Border.all(
            color: isDark ? AppColors.border : AppColors.borderLight,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.blackColor.withValues(
                alpha: isDark ? 0.3 : 0.1,
              ),
              blurRadius: 10,
              offset: const Offset(0, 3)
            )
          ]
        ),
        child: Icon(
          Icons.near_me_rounded,
          color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
          size: 20
        )
      )
    );

  }

}

class _CityMarker {

  final String city;
  final double latitude;
  final double longitude;
  final bool highlighted;

  const _CityMarker(this.city, this.latitude, this.longitude, this.highlighted);

}

const String _darkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#121212"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8c8c8c"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#121212"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#1f1f1f"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1a1a1a"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1a1a1a"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#242424"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1a1a1a"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#0a0a0a"
      }
    ]
  }
]
''';

const String _lightMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e9e9e9"
      }
    ]
  }
]
''';