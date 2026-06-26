import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/features/home/bloc/home_event.dart';
import 'package:zetra/features/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeState.initial()) {
    on<HomeInitialized>(_onHomeInitialized);
    on<LocationRequested>(_onLocationRequested);
    on<NearestStationDismissed>(_onNearestStationDismissed);
    on<NearestStationShown>(_onNearestStationShown);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<NavigationTabChanged>(_onNavigationTabChanged);
  }

  Future<void> _onHomeInitialized(HomeInitialized event, Emitter<HomeState> emit) async {

    emit(state.copyWith(
        status: HomeStatus.loading
    ));

    await Future<void>.delayed(const Duration(
        milliseconds: 400
    ));

    emit(state.copyWith(
      status: HomeStatus.loaded,
      showNearestStation: true,
      nearestStation: const NearestStationData(
        name: 'ZETRA GreenCharge Hub',
        type: 'DC Fast 150kW',
        distanceKm: 2.1,
        availableCount: 8
      )
    ));

  }

  void _onLocationRequested(LocationRequested event, Emitter<HomeState> emit) {

    emit(state.copyWith(
      showNearestStation: true,
      nearestStation: const NearestStationData(
        name: 'ZETRA GreenCharge Hub',
        type: 'DC Fast 150kW',
        distanceKm: 2.1,
        availableCount: 8
      )
    ));

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