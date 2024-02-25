import 'package:flutter/material.dart';

// This just provides whether the location has been loaded or not
class LocationModel extends ChangeNotifier {
  bool _loaded = false;

  bool get loaded => _loaded;
  set loaded(bool value) {
    _loaded = value;
    notifyListeners();
  }
}
