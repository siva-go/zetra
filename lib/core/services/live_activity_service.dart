import 'dart:developer';

import 'package:flutter/services.dart';

class LiveActivityService {

  static const MethodChannel _channel = MethodChannel('app.zetraev.com/live_activity');

  static final LiveActivityService _instance = LiveActivityService._internal();
  static LiveActivityService get instance => _instance;

  LiveActivityService._internal();

  /// Initializes the service and registers a callback for stop requested from lock screen.
  void init({required Function() onStopRequested}) {

    _channel.setMethodCallHandler((MethodCall call) async {

      if (call.method == 'stopChargingFromNotification') {

        onStopRequested();

      }

    });

  }

  /// Starts the lock screen live activity / custom notification.
  Future<void> start({
    required double soc,
    required int timeRemainingMins,
    required double speedKw,
    required double costRm,
    required bool isDarkMode,
  }) async {

    try {

      await _channel.invokeMethod('startLiveActivity', {
        'soc': soc,
        'timeRemainingMins': timeRemainingMins,
        'speedKw': speedKw,
        'costRm': costRm,
        'isDarkMode': isDarkMode,
      });

    } on PlatformException catch (e) {

      // Log or handle error gracefully in release
      log('Failed to start Live Activity: ${e.message}');

    }

  }

  /// Updates the lock screen live activity / custom notification with new metrics.
  Future<void> update({
    required double soc,
    required int timeRemainingMins,
    required double speedKw,
    required double costRm,
    required bool isDarkMode,
  }) async {

    try {

      await _channel.invokeMethod('updateLiveActivity', {
        'soc': soc,
        'timeRemainingMins': timeRemainingMins,
        'speedKw': speedKw,
        'costRm': costRm,
        'isDarkMode': isDarkMode,
      });

    } on PlatformException catch (e) {

      log('Failed to update Live Activity: ${e.message}');

    }

  }

  /// Stops/dismisses the Live Activity / notification.
  Future<void> stop() async {

    try {

      await _channel.invokeMethod('stopLiveActivity');

    } on PlatformException catch (e) {

      log('Failed to stop Live Activity: ${e.message}');

    }

  }

}