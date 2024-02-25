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

  static void vibrate(BuildContext context) {
    if (canVibrate(context)) {
      HapticFeedback.vibrate();
    }
  }

  static void heavyImpact(BuildContext context) {
    if (canVibrate(context)) {
      HapticFeedback.heavyImpact();
    }
  }

  static void mediumImpact(BuildContext context) {
    if (canVibrate(context)) {
      HapticFeedback.mediumImpact();
    }
  }

  static void lightImpact(BuildContext context) {
    if (canVibrate(context)) {
      HapticFeedback.lightImpact();
    }
  }
}