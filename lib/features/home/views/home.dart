import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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
  final BitmapDescriptor _defaultIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  final BitmapDescriptor _selectedIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);

  static const List<_StationMarkerData> _stations = <_StationMarkerData>[
    _StationMarkerData(
      id: 'Chandigarh',
      city: 'Chandigarh',
      latitude: 30.7333,
        longitude: 76.7794,
      name: 'ZETRA NorthPark Station',
        type: 'AC Type 2  7kW',
      distanceKm: 18.4,
        availableCount: 5
    ),
    _StationMarkerData(
      id: 'Delhi',
      city: 'Delhi',
      latitude: 28.6139,
        longitude: 77.2090,
      name: 'ZETRA Capital Hub',
        type: 'DC Fast 150kW',
      distanceKm: 3.6,
        availableCount: 12
    ),
    _StationMarkerData(
      id: 'Lucknow',
      city: 'Lucknow',
      latitude: 26.8467,
        longitude: 80.9462,
      name: 'ZETRA Gomti Station',
        type: 'DC Fast 60kW',
      distanceKm: 5.1,
        availableCount: 4
    ),
    _StationMarkerData(
      id: 'Kolkata',
      city: 'Kolkata',
      latitude: 22.5726,
        longitude: 88.3639,
      name: 'ZETRA East Hub',
        type: 'DC Fast 150kW',
      distanceKm: 7.2,
        availableCount: 9
    ),
    _StationMarkerData(
      id: 'Ahmedabad',
      city: 'Ahmedabad',
      latitude: 23.0225,
        longitude: 72.5714,
      name: 'ZETRA Gujarat Hub',
        type: 'AC Type 2  7kW',
      distanceKm: 4.3,
        availableCount: 6
    ),
    _StationMarkerData(
      id: 'Indore',
      city: 'Indore',
      latitude: 22.7196,
        longitude: 75.8577,
      name: 'ZETRA MP Station',
        type: 'DC Fast 60kW',
      distanceKm: 2.8,
        availableCount: 3
    ),
    _StationMarkerData(
      id: 'Bhopal',
      city: 'Bhopal',
      latitude: 23.2599,
        longitude: 77.4126,
      name: 'ZETRA Bhopal Hub',
        type: 'AC Type 2  7kW',
      distanceKm: 6.7,
        availableCount: 7
    ),
    _StationMarkerData(
      id: 'Nagpur',
      city: 'Nagpur',
      latitude: 21.1458,
        longitude: 79.0882,
      name: 'ZETRA Orange City',
        type: 'DC Fast 150kW',
      distanceKm: 3.2,
        availableCount: 10
    ),
    _StationMarkerData(
      id: 'Mumbai',
      city: 'Mumbai',
      latitude: 19.0760,
        longitude: 72.8777,
      name: 'ZETRA GreenCharge Hub',
        type: 'DC Fast 150kW',
      distanceKm: 2.1,
        availableCount: 8
    ),
    _StationMarkerData(
      id: 'Hyderabad',
      city: 'Hyderabad',
      latitude: 17.3850,
        longitude: 78.4867,
      name: 'ZETRA Cyber Hub',
        type: 'DC Fast 150kW',
      distanceKm: 4.9,
        availableCount: 11
    ),
    _StationMarkerData(
      id: 'Bengaluru',
      city: 'Bengaluru',
      latitude: 12.9716,
        longitude: 77.5946,
      name: 'ZETRA Silicon Station',
        type: 'DC CCS2 250kW',
      distanceKm: 1.8,
        availableCount: 6
    ),
    _StationMarkerData(
      id: 'Chennai',
      city: 'Chennai',
      latitude: 13.0827,
        longitude: 80.2707,
      name: 'ZETRA Marina Hub',
        type: 'DC Fast 60kW',
      distanceKm: 3.4,
        availableCount: 4
    )
  ];

  @override
  void initState() {

    super.initState();
    context.read<HomeBloc>().add(HomeInitialized());

  }

  @override
  void dispose() {

    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: AppColors.navBackground,
        systemNavigationBarIconBrightness: Brightness.light
      )
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (BuildContext context, HomeState state) {

            final Set<Marker> markers = _stations.map((_StationMarkerData station) {

              final bool isSelected = state.selectedStationId == station.id;

              return Marker(
                markerId: MarkerId(station.id),
                position: LatLng(station.latitude, station.longitude),
                icon: isSelected ? _selectedIcon : _defaultIcon,
                infoWindow: InfoWindow(
                    title: station.city
                ),
                zIndex: isSelected ? 2.0 : 1.0,
                onTap: () {

                  HapticFeedback.selectionClick();

                  context.read<HomeBloc>().add(StationSelected(
                    stationId: station.id,
                    name: station.name,
                    type: station.type,
                    distanceKm: station.distanceKm,
                    availableCount: station.availableCount
                  ));

                }
              );

            }).toSet();

            return Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(11, 79),
                            zoom: 6.8
                          ),
                          style: isDark ? _darkMapStyle : _lightMapStyle,
                          onMapCreated: (GoogleMapController controller) {

                            _mapController = controller;

                          },
                          markers: markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          buildingsEnabled: false
                        )
                      ),
                      Positioned(
                        top: 16.h,
                        left: 0,
                        right: 0,
                        child: _buildSearchBar(isDark)
                      ),
                      if (state.showNearestStation && state.nearestStation != null)
                        Positioned(
                          bottom: 10.h,
                          left: 12.w,
                          right: 12.w,
                          child: NearestStationCard(
                            station: state.nearestStation!,
                            isDark: isDark,
                            onDismiss: () {

                              context.read<HomeBloc>().add(NearestStationDismissed());

                            },
                            onScanQr: () {

                              HapticFeedback.mediumImpact();

                            }
                          )
                        ),
                      Positioned(
                        bottom: state.showNearestStation ? 205.h : 20.h,
                        right: 18.w,
                        child: _buildLocateButton(isDark)
                      )
                    ]
                  )
                ),
                const ZetraBottomNavBar(
                  currentIndex: 0,
                )
              ]
            );

          }
        )
      )
    );

  }



  Widget _buildSearchBar(bool isDark) {

    final Color cardBg = isDark ? const Color(0xFF141927).withValues(
        alpha: 0.92
    ) : AppColors.whiteColor.withValues(
        alpha: 0.94
    );
    final Color borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final Color hintColor = isDark ? AppColors.textHint : AppColors.textHintLight;
    final Color iconColor = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 16.w
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 14,
              sigmaY: 14
          ),
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                  color: borderColor
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.blackColor.withValues(
                      alpha: isDark ? 0.3 : 0.07
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 3)
                )
              ]
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                    width: 12.w
                ),
                Icon(
                    Icons.search_rounded,
                    color: iconColor,
                    size: 20
                ),
                SizedBox(
                    width: 8.w
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    readOnly: true,
                    onTap: () {

                      context.push('/search-station');

                    },
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 13.sp,
                      color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'Search location or station',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        fontSize: 13.sp,
                        color: hintColor
                      ),
                      contentPadding: EdgeInsets.zero
                    )
                  )
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: borderColor
                ),
                SizedBox(
                    width: 10.w
                ),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                      Icons.tune_rounded,
                      color: iconColor,
                      size: 20
                  )
                ),
                SizedBox(
                    width: 12.w
                )
              ]
            )
          )
        )
      )
    ).animate().fade(
        delay: 80.ms,
        duration: 500.ms
    ).slideY(
        begin: -0.1,
        curve: Curves.easeOutCubic
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
              target: LatLng(8.7642, 78.1348),
              zoom: 10
            )
          )
        );

      },
      child: Container(
        width: 36.w,
        height: 33.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDark ? AppColors.cardDark : AppColors.whiteColor,
          border: Border.all(
            color: isDark ? AppColors.border : AppColors.borderLight
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.blackColor.withValues(
                  alpha: isDark ? 0.35 : 0.12
              ),
              blurRadius: 12,
              offset: const Offset(0, 3)
            )
          ]
        ),
        child: FaIcon(
          FontAwesomeIcons.locationArrow,
          color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight
        )
      )
    );

  }

}

class _StationMarkerData {

  final String id;
  final String city;
  final double latitude;
  final double longitude;
  final String name;
  final String type;
  final double distanceKm;
  final int availableCount;

  const _StationMarkerData({required this.id, required this.city, required this.latitude, required this.longitude, required this.name, required this.type, required this.distanceKm, required this.availableCount});

}

const String _darkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#0a0e17"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#8c8c8c"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#0a0e17"}]},
  {"featureType":"administrative.country","elementType":"geometry.stroke","stylers":[{"color":"#00C853"},{"weight":1.2}]},
  {"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#1f2a3a"}]},
  {"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#0d1220"}]},
  {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#141927"}]},
  {"featureType":"poi","elementType":"labels","stylers":[{"visibility":"off"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#1a2234"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#1e2740"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#1e2a40"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#6e7a8a"}]},
  {"featureType":"transit","elementType":"geometry","stylers":[{"color":"#141927"}]},
  {"featureType":"transit","elementType":"labels","stylers":[{"visibility":"off"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#060b14"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#1a4060"}]}
]
''';

const String _lightMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#f0f4f8"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#6e7387"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#f0f4f8"}]},
  {"featureType":"administrative.country","elementType":"geometry.stroke","stylers":[{"color":"#00C853"},{"weight":1.2}]},
  {"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#c8d0e0"}]},
  {"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#eef1f8"}]},
  {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#e4e9f4"}]},
  {"featureType":"poi","elementType":"labels","stylers":[{"visibility":"off"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#e0e4ef"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#f5f7fb"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ea3b7"}]},
  {"featureType":"transit","elementType":"geometry","stylers":[{"color":"#e8ecf6"}]},
  {"featureType":"transit","elementType":"labels","stylers":[{"visibility":"off"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#d0e8f4"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#7eaec9"}]}
]
''';