import 'package:flutter/foundation.dart';
import 'package:zetra/features/profile/models/driver_vehicle_model.dart';
import 'package:zetra/features/profile/models/user_profile_model.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error
}

@immutable
class ProfileState {

  final ProfileStatus status;
  final UserProfileModel? user;
  final List<DriverVehicleModel> vehicles;
  final bool isUpdating;
  final bool isLoadingVehicles;
  final String? errorMessage;
  final String? successMessage;

  const ProfileState({
    required this.status,
    this.user,
    this.vehicles = const <DriverVehicleModel>[],
    this.isUpdating = false,
    this.isLoadingVehicles = false,
    this.errorMessage,
    this.successMessage
  });

  factory ProfileState.initial() {

    return const ProfileState(
      status: ProfileStatus.initial
    );

  }

  bool get isLoading => status == ProfileStatus.loading;
  bool get isLoaded => status == ProfileStatus.loaded;
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
  bool get hasSuccess => successMessage != null && successMessage!.isNotEmpty;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileModel? user,
    List<DriverVehicleModel>? vehicles,
    bool? isUpdating,
    bool? isLoadingVehicles,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false
  }) {

    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      vehicles: vehicles ?? this.vehicles,
      isUpdating: isUpdating ?? this.isUpdating,
      isLoadingVehicles: isLoadingVehicles ?? this.isLoadingVehicles,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage)
    );

  }

}