import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zetra/features/home/bloc/home_event.dart';
import 'package:zetra/features/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeState.initial()) {
    on<HomeInitialized>(_onHomeInitialized);
    on<LocationRequested>(_onLocationRequested);
    on<NearestStationDismissed>(_onNearestStationDismissed);
    on<NearestStationShown>(_onNearestStationShown);
    on<StationSelected>(_onStationSelected);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<NavigationTabChanged>(_onNavigationTabChanged);
  }

  static const List<StationInfo> _allStations = <StationInfo>[
    StationInfo(
      id: 'Chandigarh',
        city: 'Chandigarh',
        latitude: 30.7333,
        longitude: 76.7794,
      name: 'ZETRA NorthPark Station',
        type: 'AC Type 2  7kW',
        availableCount: 5
    ),
    StationInfo(
      id: 'Delhi',
        city: 'Delhi',
        latitude: 28.6139,
        longitude: 77.2090,
      name: 'ZETRA Capital Hub',
        type: 'DC Fast 150kW',
        availableCount: 12
    ),
    StationInfo(
      id: 'Lucknow',
        city: 'Lucknow',
        latitude: 26.8467,
        longitude: 80.9462,
      name: 'ZETRA Gomti Station',
        type: 'DC Fast 60kW',
        availableCount: 4
    ),
    StationInfo(
      id: 'Kolkata',
        city: 'Kolkata',
        latitude: 22.5726,
        longitude: 88.3639,
      name: 'ZETRA East Hub',
        type: 'DC Fast 150kW',
        availableCount: 9
    ),
    StationInfo(
      id: 'Ahmedabad',
        city: 'Ahmedabad',
        latitude: 23.0225,
        longitude: 72.5714,
      name: 'ZETRA Gujarat Hub',
        type: 'AC Type 2  7kW',
        availableCount: 6
    ),
    StationInfo(
      id: 'Indore',
        city: 'Indore',
        latitude: 22.7196,
        longitude: 75.8577,
      name: 'ZETRA MP Station',
        type: 'DC Fast 60kW',
        availableCount: 3
    ),
    StationInfo(
      id: 'Bhopal',
        city: 'Bhopal',
        latitude: 23.2599,
        longitude: 77.4126,
      name: 'ZETRA Bhopal Hub',
        type: 'AC Type 2  7kW',
        availableCount: 7
    ),
    StationInfo(
      id: 'Nagpur',
        city: 'Nagpur',
        latitude: 21.1458,
        longitude: 79.0882,
      name: 'ZETRA Orange City',
        type: 'DC Fast 150kW',
        availableCount: 10
    ),
    StationInfo(
      id: 'Mumbai',
        city: 'Mumbai',
        latitude: 19.0760,
        longitude: 72.8777,
      name: 'ZETRA GreenCharge Hub',
        type: 'DC Fast 150kW',
        availableCount: 8
    ),
    StationInfo(
      id: 'Hyderabad',
        city: 'Hyderabad',
        latitude: 17.3850,
        longitude: 78.4867,
      name: 'ZETRA Cyber Hub',
        type: 'DC Fast 150kW',
        availableCount: 11
    ),
    StationInfo(
      id: 'Bengaluru',
        city: 'Bengaluru',
        latitude: 12.9716,
        longitude: 77.5946,
      name: 'ZETRA Silicon Station',
        type: 'DC CCS2 250kW',
        availableCount: 6
    ),
    StationInfo(
      id: 'Chennai',
        city: 'Chennai',
        latitude: 13.0827,
        longitude: 80.2707,
      name: 'ZETRA Marina Hub',
        type: 'DC Fast 60kW',
        availableCount: 4
    )
  ];

  Future<void> _onHomeInitialized(HomeInitialized event, Emitter<HomeState> emit) async {

    emit(state.copyWith(
        status: HomeStatus.loading
    ));

    final NearestStationData nearest = await _calculateNearestStation();

    emit(state.copyWith(
      status: HomeStatus.loaded,
      showNearestStation: true,
      selectedStationId: nearest.id,
      nearestStation: nearest
    ));

  }

  Future<void> _onLocationRequested(LocationRequested event, Emitter<HomeState> emit) async {

    final NearestStationData nearest = await _calculateNearestStation();

    emit(state.copyWith(
      showNearestStation: true,
      selectedStationId: nearest.id,
      nearestStation: nearest
    ));

  }

  Future<NearestStationData> _calculateNearestStation() async {

    double userLat = 8.7642;
    double userLng = 78.1348;

    try {

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {

        permission = await Geolocator.requestPermission();

      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {

        final Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(
                seconds: 2
            )
          )
        );

        userLat = position.latitude;
        userLng = position.longitude;

      }

    } catch (_) {}

    StationInfo nearest = _allStations.last;
    double minDistance = double.infinity;

    for (final StationInfo station in _allStations) {

      final double dist = Geolocator.distanceBetween(
        userLat,
        userLng,
        station.latitude,
        station.longitude
      ) / 1000.0;

      if (dist < minDistance) {

        minDistance = dist;
        nearest = station;

      }

    }

    final double distanceKm = double.parse(minDistance.toStringAsFixed(1));

    return NearestStationData(
      id: nearest.id,
      name: nearest.name,
      type: nearest.type,
      distanceKm: distanceKm,
      availableCount: nearest.availableCount
    );

  }

  void _onNearestStationDismissed(NearestStationDismissed event, Emitter<HomeState> emit) {

    emit(state.copyWith(
        showNearestStation: false
    ));

  }

  void _onNearestStationShown(NearestStationShown event, Emitter<HomeState> emit) {

    emit(state.copyWith(
        showNearestStation: true
    ));

  }

  void _onStationSelected(StationSelected event, Emitter<HomeState> emit) {

    emit(state.copyWith(
      showNearestStation: true,
      selectedStationId: event.stationId,
      nearestStation: NearestStationData(
        id: event.stationId,
        name: event.name,
        type: event.type,
        distanceKm: event.distanceKm,
        availableCount: event.availableCount
      )
    ));

  }

  void _onSearchQueryChanged(SearchQueryChanged event, Emitter<HomeState> emit) {

    emit(state.copyWith(
        searchQuery: event.query
    ));

  }

  void _onNavigationTabChanged(NavigationTabChanged event, Emitter<HomeState> emit) {

    emit(state.copyWith(
        currentNavIndex: event.index
    ));

  }

}

class StationInfo {

  final String id;
  final String city;
  final double latitude;
  final double longitude;
  final String name;
  final String type;
  final int availableCount;

  const StationInfo({
    required this.id,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.type,
    required this.availableCount
  });

}