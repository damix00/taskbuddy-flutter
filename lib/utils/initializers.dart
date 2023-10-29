import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/state/providers/preferences.dart';

class Initializers {
  static Future<void> initCache(BuildContext context) async {
    PreferencesModel prefs =
        Provider.of<PreferencesModel>(context, listen: false);

    AuthModel auth = Provider.of<AuthModel>(context, listen: false);

    // Initialize the preferences
    await prefs.init();

    // Initialize the auth
    await auth.init();
  }
}
