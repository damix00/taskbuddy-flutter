import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/preferences.dart';

// Haptic feedback utilities
// Used to provide haptic feedback to the user, if enabled
class HapticFeedbackUtils {
  static bool canVibrate(BuildContext context) {
    PreferencesModel prefs = Provider.of<PreferencesModel>(context, listen: false);

    return prefs.hapticFeedback;
  }

  static Future<void> vibrate(BuildContext context) async {
    if (canVibrate(context)) {
      HapticFeedback.vibrate();
    }
  }

  static Future<void> heavyImpact(BuildContext context) async {
    if (Platform.isAndroid) {
      vibrate(context);
    }

    else if (canVibrate(context)) {
      HapticFeedback.heavyImpact();
    }
  }

  static Future<void> mediumImpact(BuildContext context) async {
    if (Platform.isAndroid) {
      vibrate(context);
    }

    else if (canVibrate(context)) {
      HapticFeedback.mediumImpact();
    }
  }

  static Future<void> lightImpact(BuildContext context) async {
    if (Platform.isAndroid) {
      vibrate(context);
    }

    else if (canVibrate(context)) {
      HapticFeedback.lightImpact();
    }
  }
}