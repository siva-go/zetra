import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zetra/core/api/result.dart';
import 'package:zetra/features/profile/bloc/profile_event.dart';
import 'package:zetra/features/profile/bloc/profile_state.dart';
import 'package:zetra/features/profile/models/driver_vehicle_model.dart';
import 'package:zetra/features/profile/models/user_profile_model.dart';
import 'package:zetra/features/profile/repository/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final ProfileRepository _repository;

  ProfileBloc(this._repository) : super(ProfileState.initial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileRefreshed>(_onRefreshed);
    on<ProfileUpdateRequested>(_onUpdateRequested);
    on<ProfileVehiclesLoadRequested>(_onVehiclesLoadRequested);
    on<ProfileClearMessages>(_onClearMessages);
  }

  Future<void> _onLoadRequested(ProfileLoadRequested event, Emitter<ProfileState> emit) async {

    if (state.user == null) {

      emit(state.copyWith(
        status: ProfileStatus.loading,
        clearError: true,
        clearSuccess: true
      ));

    }

    final Future<Result<UserProfileModel>> profileFuture = _repository.fetchUserProfile();
    final Future<Result<VehiclesPage>> vehiclesFuture = _repository.fetchDriverVehicles();

    final List<dynamic> results = await Future.wait<dynamic>(<Future<dynamic>>[
      profileFuture,
      vehiclesFuture
    ]);

    final Result<UserProfileModel> profileRes = results[0] as Result<UserProfileModel>;
    final Result<VehiclesPage> vehiclesRes = results[1] as Result<VehiclesPage>;

    if (profileRes.isSuccess) {

      final List<DriverVehicleModel> vehicles = vehiclesRes.isSuccess ? (vehiclesRes.dataOrNull?.data ?? <DriverVehicleModel>[]) : state.vehicles;

      emit(state.copyWith(
        status: ProfileStatus.loaded,
        user: profileRes.dataOrNull,
        vehicles: vehicles,
        clearError: true
      ));

    } else {

      final dynamic failure = profileRes.failureOrNull;
      final String msg = failure?.message?.toString() ?? failure?.toString() ?? 'Failed to load profile details.';

      emit(state.copyWith(
        status: state.user != null ? ProfileStatus.loaded : ProfileStatus.error,
        errorMessage: msg
      ));

    }

  }

  Future<void> _onRefreshed(ProfileRefreshed event, Emitter<ProfileState> emit) async {

    final Result<UserProfileModel> profileRes = await _repository.fetchUserProfile();
    final Result<VehiclesPage> vehiclesRes = await _repository.fetchDriverVehicles();

    if (profileRes.isSuccess) {

      final List<DriverVehicleModel> vehicles = vehiclesRes.isSuccess ? (vehiclesRes.dataOrNull?.data ?? state.vehicles) : state.vehicles;

      emit(state.copyWith(
        status: ProfileStatus.loaded,
        user: profileRes.dataOrNull,
        vehicles: vehicles,
        clearError: true
      ));

    }

  }

  Future<void> _onUpdateRequested(ProfileUpdateRequested event, Emitter<ProfileState> emit) async {

    emit(state.copyWith(
      isUpdating: true,
      clearError: true,
      clearSuccess: true
    ));

    final Result<UserProfileModel> result = await _repository.updateUserProfile(
      fullName: event.fullName,
      email: event.email,
      phone: event.phone
    );

    if (result.isSuccess) {

      emit(state.copyWith(
        isUpdating: false,
        user: result.dataOrNull,
        successMessage: 'Profile updated successfully.'
      ));

    } else {

      final dynamic failure = result.failureOrNull;
      final String msg = failure?.message?.toString() ?? failure?.toString() ?? 'Failed to update profile. Please try again.';

      emit(state.copyWith(
        isUpdating: false,
        errorMessage: msg
      ));

    }

  }

  Future<void> _onVehiclesLoadRequested(ProfileVehiclesLoadRequested event, Emitter<ProfileState> emit) async {

    emit(state.copyWith(
        isLoadingVehicles: true
    ));

    final Result<VehiclesPage> result = await _repository.fetchDriverVehicles();

    if (result.isSuccess) {

      emit(state.copyWith(
        vehicles: result.dataOrNull?.data ?? <DriverVehicleModel>[],
        isLoadingVehicles: false
      ));

    } else {

      emit(state.copyWith(
        isLoadingVehicles: false
      ));

    }

  }

  void _onClearMessages(ProfileClearMessages event, Emitter<ProfileState> emit) {

    emit(state.copyWith(
      clearError: true,
      clearSuccess: true
    ));

  }

}