import 'package:flutter/material.dart';


class LocationModel extends ChangeNotifier {
  bool _loaded = false;

  bool get loaded => _loaded;
  set loaded(bool value) {
    _loaded = value;
    notifyListeners();
  }
}
