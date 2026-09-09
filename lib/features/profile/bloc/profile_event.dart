import 'package:flutter/foundation.dart';

@immutable
abstract class ProfileEvent {

  const ProfileEvent();

}

class ProfileLoadRequested extends ProfileEvent {

  const ProfileLoadRequested();

}

class ProfileRefreshed extends ProfileEvent {

  const ProfileRefreshed();

}

class ProfileUpdateRequested extends ProfileEvent {

  final String? fullName;
  final String? email;
  final String? phone;

  const ProfileUpdateRequested({
    this.fullName,
    this.email,
    this.phone
  });

}

class ProfileVehiclesLoadRequested extends ProfileEvent {

  const ProfileVehiclesLoadRequested();

}

class ProfileClearMessages extends ProfileEvent {

  const ProfileClearMessages();

}