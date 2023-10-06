import 'package:flutter/material.dart';
import 'package:taskbuddy/cache/account_cache.dart';

class AuthModel extends ChangeNotifier {
  bool _finishedLoading = false;
  bool _loggedIn = false;
  String _username = '';
  String _profilePicture = '';
  bool _isPrivate = false;
  int _followers = 0;
  int _following = 0;
  int _listings = 0;
  int _jobsDone = 0;
  String _bio = '';
  num _employerRating = 0;
  num _employeeRating = 0;
  int _employerCancelled = 0;
  int _employeeCancelled = 0;
  String _fullName = '';
  String _locationText = '';

  bool get finishedLoading => _finishedLoading;
  bool get loggedIn => _loggedIn;
  String get username => _username;
  String get profilePicture => _profilePicture;
  bool get isPrivate => _isPrivate;
  int get followers => _followers;
  int get following => _following;
  int get listings => _listings;
  int get jobsDone => _jobsDone;
  String get bio => _bio;
  num get employerRating => _employerRating;
  num get employeeRating => _employeeRating;
  int get employerCancelled => _employerCancelled;
  int get employeeCancelled => _employeeCancelled;
  String get fullName => _fullName;
  String get locationText => _locationText;

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

  set isPrivate(bool value) {
    _isPrivate = value;
    notifyListeners();
  }

  set followers(int value) {
    _followers = value;
    notifyListeners();
  }

  set following(int value) {
    _following = value;
    notifyListeners();
  }

  set listings(int value) {
    _listings = value;
    notifyListeners();
  }

  set jobsDone(int value) {
    _jobsDone = value;
    notifyListeners();
  }

  set bio(String value) {
    _bio = value;
    notifyListeners();
  }

  set employerRating(num value) {
    _employerRating = value;
    notifyListeners();
  }

  set employeeRating(num value) {
    _employeeRating = value;
    notifyListeners();
  }

  set employerCancelled(int value) {
    _employerCancelled = value;
    notifyListeners();
  }

  set employeeCancelled(int value) {
    _employeeCancelled = value;
    notifyListeners();
  }

  set fullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  set locationText(String value) {
    _locationText = value;
    notifyListeners();
  }

  Future<void> init() async {
    var loggedIn = await AccountCache.isLoggedIn();

    if (loggedIn) {
      var username = await AccountCache.getUsername();
      var profilePicture = await AccountCache.getProfilePicture();
      var isPrivate = await AccountCache.isPrivate();
      var followers = await AccountCache.getFollowers();
      var following = await AccountCache.getFollowing();
      var listings = await AccountCache.getPosts();
      var jobsDone = await AccountCache.getCompletedJobs();
      var bio = await AccountCache.getBio();
      var employerRating = await AccountCache.getEmployerRating();
      var employeeRating = await AccountCache.getEmployeeRating();
      var employerCancelled = await AccountCache.getEmployerCancelled();
      var employeeCancelled = await AccountCache.getEmployeeCancelled();
      var fullName = await AccountCache.getFullName();
      var locationText = await AccountCache.getLocationText();

      _username = username;
      _profilePicture = profilePicture;
      _isPrivate = isPrivate;
      _followers = followers;
      _following = following;
      _listings = listings;
      _jobsDone = jobsDone;
      _bio = bio;
      _employerRating = employerRating;
      _employeeRating = employeeRating;
      _employerCancelled = employerCancelled;
      _employeeCancelled = employeeCancelled;
      _fullName = fullName;
      _locationText = locationText;
    }

    _loggedIn = loggedIn;
    _finishedLoading = true;
  }
}