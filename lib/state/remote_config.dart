import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigData {
  static double minPrice = 1;
  static double maxPrice = 10000;

  static double minRadius = 10;
  static double maxRadius = 100;

  static Future<void> init() async {
    var remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.fetchAndActivate();

      minPrice = remoteConfig.getDouble('min_price');
      maxPrice = remoteConfig.getDouble('max_price');

      minRadius = remoteConfig.getDouble('min_radius');
      maxRadius = remoteConfig.getDouble('max_radius');
    } catch (e) {
      log('Error fetching remote config: $e');
    }
  }
}