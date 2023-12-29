import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/account/account_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';

class AuthModel extends ChangeNotifier {
  String _uuid = '';
  bool _finishedLoading = false;
  bool _loggedIn = false;
  String _username = '';
  String _email = '';
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
  int _completedEmployee = 0;
  int _completedEmployer = 0;
  String _fullName = '';
  String _firstName = '';
  String _lastName = '';
  num? _lat;
  num? _lon;
  String _locationText = '';
  AccountResponseRequiredActions? _requiredActions;

  String get UUID => _uuid;
  bool get finishedLoading => _finishedLoading;
  bool get loggedIn => _loggedIn;
  String get username => _username;
  String get email => _email;
  String get profilePicture => _profilePicture;
  bool get isPrivate => _isPrivate;
  int get followers => _followers;
  int get following => _following;
  int get listings => _listings;
  int get jobsDone => _jobsDone;
  int get completedEmployee => _completedEmployee;
  int get completedEmployer => _completedEmployer;
  String get bio => _bio;
  num get employerRating => _employerRating;
  num get employeeRating => _employeeRating;
  int get employerCancelled => _employerCancelled;
  int get employeeCancelled => _employeeCancelled;
  String get fullName => _fullName;
  String get firstName => _firstName;
  String get lastName => _lastName;
  num? get lat {
    return _lat;
  }
  num? get lon {
    return _lon;
  }
  String get locationText => _locationText;
  AccountResponseRequiredActions? get requiredActions => _requiredActions;

  set UUID(String value) {
    _uuid = value;
    notifyListeners();
  }

  set completedEmployee(int value) {
    _completedEmployee = value;
    notifyListeners();
  }

  set completedEmployer(int value) {
    _completedEmployer = value;
    notifyListeners();
  }

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

  set email(String value) {
    _email = value;
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

  set firstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  set lastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  set lat(num? value) {
    _lat = value;
    notifyListeners();
  }

  set lon(num? value) {
    _lon = value;
    notifyListeners();
  }

  set locationText(String value) {
    _locationText = value;
    notifyListeners();
  }

  set requiredActions(AccountResponseRequiredActions? value) {
    _requiredActions = value;
    notifyListeners();
  }

  Future<void> init() async {
    var loggedIn = await AccountCache.isLoggedIn();

    if (loggedIn) {
      var username = await AccountCache.getUsername();
      var email = await AccountCache.getEmail();
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
      var firstName = await AccountCache.getFirstName();
      var lastName = await AccountCache.getLastName();
      var locationText = await AccountCache.getLocationText();
      var lat = await AccountCache.getLatitude();
      var lon = await AccountCache.getLongitude();
      var requiredActions = await AccountCache.getRequiredActions();
      var uuid = await AccountCache.getUUID();

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
      _firstName = firstName;
      _lastName = lastName;
      _locationText = locationText;
      _requiredActions = requiredActions;
      _email = email;
      _lat = lat;
      _lon = lon;
      _uuid = uuid;
    }

    _loggedIn = loggedIn;

    notifyListeners();
  }

  void setAccountResponse(AccountResponse response) {
    _username = response.user.username;
    _profilePicture = response.profile!.profilePicture;
    _isPrivate = response.profile!.isPrivate;
    _followers = response.profile!.followers;
    _following = response.profile!.following;
    _listings = response.profile!.posts;
    _jobsDone = response.profile!.completedEmployee +
        response.profile!.completedEmployer;
    _completedEmployee = response.profile!.completedEmployee;
    _completedEmployer = response.profile!.completedEmployer;
    _bio = response.profile!.bio;
    _employerRating = response.profile!.ratingEmployer;
    _employeeRating = response.profile!.ratingEmployee;
    _employerCancelled = response.profile!.cancelledEmployer;
    _employeeCancelled = response.profile!.cancelledEmployee;
    _fullName = '${response.user.firstName} ${response.user.lastName}';
    _firstName = response.user.firstName;
    _lastName = response.user.lastName;
    _locationText = response.profile!.locationText;
    _requiredActions = response.requiredActions;
    _email = response.user.email;
    _loggedIn = true;
    _finishedLoading = true;
    _lat = response.profile!.locationLat;
    _lon = response.profile!.locationLon;
    _uuid = response.user.uuid;

    notifyListeners();
  }

  Future<void> logout() async {
    await AccountCache.setLoggedIn(false);
    await AccountCache.clear();

    _loggedIn = false;
    _finishedLoading = true;
    _username = '';
    _profilePicture = '';
    _isPrivate = false;
    _followers = 0;
    _following = 0;
    _listings = 0;
    _jobsDone = 0;
    _bio = '';
    _employerRating = 0;
    _employeeRating = 0;
    _employerCancelled = 0;
    _employeeCancelled = 0;
    _fullName = '';
    _firstName = '';
    _lastName = '';
    _locationText = '';
    _requiredActions = null;
    _email = '';
    _lat = null;
    _lon = null;
    _uuid = '';

    notifyListeners();
  }
}
