// Account cache is used to store the account information of the user
// Stored using secure storage to prevent tampering
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskbuddy/api/responses/account_response.dart';
import 'package:taskbuddy/api/responses/profile_response.dart';

// Class responsible for caching account-related data using secure storage
class AccountCache {
  // Read a value from the storage based on a given key
  static Future<String?> _readKey(String key) async {
    var storage = const FlutterSecureStorage(); // Initialize the secure storage
    return await storage.read(
        key: key); // Read the value associated with the key
  }

  // Write a value to the storage based on a given key
  static Future<void> _writeKey(String key, String value) async {
    var storage = const FlutterSecureStorage(); // Initialize the secure storage
    await storage.write(
        key: key, value: value); // Write the value associated with the key
  }

  // Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    return await _readKey('isLoggedIn') == 'true'; // Read and compare the value
  }

  // Set the logged-in status in the storage
  static Future<void> setLoggedIn(bool value) async {
    await _writeKey('isLoggedIn', value.toString()); // Write the boolean value
  }

  // Get the token from the storage
  static Future<String?> getToken() async {
    return await _readKey('token'); // Read the token value
  }

  // Set the token in the storage
  static Future<void> setToken(String value) async {
    await _writeKey('token', value); // Write the token value
  }

  static Future<void> setFullName(String firstName, String lastName) async {
    await _writeKey(
        'fullName', '$firstName $lastName');
  }

  static Future<void> setUsername(String username) async {
    await _writeKey('username', username);
  }

  static Future<void> setProfilePicture(String profilePicture) async {
    await _writeKey('profilePicture', profilePicture);
  }

  static Future<void> setBio(String bio) async {
    await _writeKey('bio', bio);
  }

  static Future<void> setFollowers(int followers) async {
    await _writeKey('followers', followers.toString());
  }

  static Future<void> setFollowing(int following) async {
    await _writeKey('following', following.toString());
  }

  static Future<void> setPosts(int posts) async {
    await _writeKey('posts', posts.toString());
  }

  static Future<void> setLocationText(String locationText) async {
    await _writeKey('locationText', locationText);
  }

  static Future<void> setIsPrivate(bool isPrivate) async {
    await _writeKey('isPrivate', isPrivate.toString());
  }

  // Get required actions from the storage
  // Required actions are actions that the user needs to perform (like verifying phone number)
  static Future<AccountResponseRequiredActions?> getRequiredActions() async {
    // Read the required actions value
    var requiredActions = await _readKey('requiredActions');
    // Convert the JSON string to a map
    var requiredActionsMap =
        requiredActions != null ? jsonDecode(requiredActions) : null;
    // Return the required actions object
    return requiredActionsMap != null
        ? AccountResponseRequiredActions.fromJson(requiredActionsMap)
        : null;
  }

  // Set required actions in the storage
  static Future<void> setRequiredActions(
      AccountResponseRequiredActions value) async {
    // Convert the required actions object to a JSON string
    var requiredActions = value.toJson();
    // Write the required actions value
    await _writeKey('requiredActions', requiredActions);
  }

  static Future<void> saveProfile(ProfileResponse profile) async {
    await setProfilePicture(profile.profilePicture);
    await setBio(profile.bio);
    await setFollowers(profile.followers);
    await setFollowing(profile.following);
    await setPosts(profile.posts);
    await setLocationText(profile.locationText);
    await setIsPrivate(profile.isPrivate);
  }

  // Save the account response in the storage
  // This method is used when the user logs in
  static Future<void> saveAccountResponse(AccountResponse value) async {
    await setToken(value.token);
    await setFullName(value.user.firstName, value.user.lastName);
    await setUsername(value.user.username);

    if (value.profile != null) {
      await saveProfile(value.profile!);
    }

    await setRequiredActions(value.requiredActions);

    await setLoggedIn(true);
  }

  // Clear the storage
  static Future<void> clear() {
    var storage = const FlutterSecureStorage();
    return storage.deleteAll();
  }
}
