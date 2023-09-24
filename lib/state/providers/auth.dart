import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _finishedLoading = false;
  bool _loggedIn = false;
  String _username = '';
  String _profilePicture = '';

  bool get finishedLoading => _finishedLoading;
  bool get loggedIn => _loggedIn;
  String get username => _username;
  String get profilePicture => _profilePicture;

  set finishedLoading(bool value) {
    _finishedLoading = value;
    notifyListeners();
  }

  set loggedIn(bool value) {
    _loggedIn = value;
    notifyListeners();
  }

  set username(String value) {
    _username = value;
    notifyListeners();
  }

  set profilePicture(String value) {
    _profilePicture = value;
    notifyListeners();
  }
}