import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesModel extends ChangeNotifier {
  bool _uiBlurEnabled = true;

  bool get uiBlurEnabled => _uiBlurEnabled;

  Future<void> setUiBlurEnabled(bool value) async {
    _uiBlurEnabled = value;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('uiBlurEnabled', value);
  }

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _uiBlurEnabled = prefs.getBool('uiBlurEnabled') ?? true;
    notifyListeners();
  }
}
