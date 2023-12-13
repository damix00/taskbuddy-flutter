import 'dart:async';

import 'package:taskbuddy/utils/utils.dart';

class LocationState {
  static double currentLat = 1000;
  static double currentLon = 1000;

  static void updateLocation() async {
    if (await Utils.canGetLocation()) {
      var loc = await Utils.getCurrentLocation();

      if (loc != null) {
        currentLat = loc.latitude;
        currentLon = loc.longitude;
      }
    }
  }

  static void setInterval() {
    Timer.periodic(const Duration(minutes: 10), (timer) {
      updateLocation();
    });
  }
}