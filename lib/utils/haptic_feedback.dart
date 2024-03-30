import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

// Haptic feedback utilities
// Used to provide haptic feedback to the user, if enabled
class HapticFeedbackUtils {
  static bool canVibrate(BuildContext context) {
    PreferencesModel prefs = Provider.of<PreferencesModel>(context, listen: false);

    return prefs.hapticFeedback;
  }

  static var _cachedSamsung = null;

  // Check if the device is a Samsung device
  // This is because Samsung devices have a different implementation of haptic feedback...
  static Future<bool> isSamsung() async {
    if (!Platform.isAndroid) {
      return false;
    }

    if (_cachedSamsung != null) {
      return _cachedSamsung;
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.manufacturer.toLowerCase() == "samsung") {
      _cachedSamsung = true;
      log("Samsung device detected.");
      return true;
    }

    _cachedSamsung = false;
    log("Non-Samsung device detected.");

    return false;
  }

  static Future<void> vibrate(BuildContext context) async {
    if (canVibrate(context)) {
      HapticFeedback.vibrate();
    }
  }

  static Future<void> heavyImpact(BuildContext context) async {
    if (await isSamsung()) {
      vibrate(context);
    }

    if (canVibrate(context)) {
      HapticFeedback.heavyImpact();
    }
  }

  static Future<void> mediumImpact(BuildContext context) async {
    if (await isSamsung()) {
      vibrate(context);
    }

    if (canVibrate(context)) {
      HapticFeedback.mediumImpact();
    }
  }

  static Future<void> lightImpact(BuildContext context) async {
    if (await isSamsung()) {
      vibrate(context);
    }

    if (canVibrate(context)) {
      HapticFeedback.lightImpact();
    }
  }
}