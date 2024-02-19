import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskbuddy/state/providers/location.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:provider/provider.dart';

class LocationState {
  static double currentLat = 1000;
  static double currentLon = 1000;
  static bool loaded = false;

  static Future<void> updateLocation(BuildContext context) async {
    if (await Utils.canGetLocation()) {
      var loc = await Utils.getCurrentLocation();

      if (loc != null) {
        currentLat = loc.latitude;
        currentLon = loc.longitude;
      }
    }
    
    if (!loaded) {
      loaded = true;
      Provider.of<LocationModel>(context, listen: false).loaded = true;
    }
  }

  static void setInterval(BuildContext context) {
    updateLocation(context);
    
    Timer.periodic(const Duration(minutes: 1), (timer) {
      updateLocation(context);
    });
  }
}
