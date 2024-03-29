import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/screens/home/home_screen.dart';
import 'package:taskbuddy/screens/signin/welcome/welcome_screen.dart';
import 'package:mime/mime.dart';

class Utils {
  // This will change default Android status bar and navigation bar colors
  static void overrideColors() {
    if (Platform.isAndroid) {
      // Select the correct brightness for the system bars
      Brightness brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                  Brightness.dark
              ? Brightness.light
              : Brightness.dark;
      
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: true,
          systemNavigationBarColor: Colors.black.withOpacity(0.002),
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: brightness,
          statusBarColor: Colors.black.withOpacity(0.002),
          statusBarIconBrightness: brightness)); // Status bar icons' color

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: [SystemUiOverlay.top]);
    }
  }

  // 1000 -> 1K, ...
  static String formatNumber(num number) {
    if (number >= 1000 && number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else if (number >= 1000000 && number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000000000 && number < 1000000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000000000 && number < 1000000000000000) {
      return '${(number / 1000000000000).toStringAsFixed(1)}T';
    }

    return number.toString();
  }

  // This will return a list that repeats the input list n times
  static T repeatList<T>(List<T> list, int times) {
    List<T> result = [];

    for (int i = 0; i < times; i++) {
      result.addAll(list);
    }

    return result as T;
  }

  // Navigate to a page without animation
  static void navigateWithoutAnim(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }

  // Restart the app, logged out
  static void restartLoggedOut(BuildContext context) {
    navigateWithoutAnim(context, const WelcomeScreen());
  }

  // Restart the app, logged in
  static void restartLoggedIn(BuildContext context) {
    navigateWithoutAnim(context, const HomeScreen());
  }

  // Distance between two coordinates (pixels)
  static num dist(Offset a, Offset b) {
    return sqrt(pow(a.dx - b.dx, 2) + pow(a.dy - b.dy, 2));
  }

  // Returns if it's possible to get the location
  static Future<bool> canGetLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return false;
    
    return true;
  }

  // Get the current location
  static Future<LatLng?> getCurrentLocation() async {
    if (!await canGetLocation()) {
      return null;
    }

    var loc = await Geolocator.getCurrentPosition();

    return LatLng(loc.latitude, loc.longitude);
  }

  // Check if the file is a video
  static bool isVideo(XFile file) {
    return lookupMimeType(file.path)!.contains('video');
  }

  // Convert a list to a string (e.g. [1, 2, 3] -> '[1, 2, 3]')
  static String listToString(List<dynamic> list) {
    String result = '[';

    for (int i = 0; i < list.length; i++) {
      result += list[i].toString();

      if (i != list.length - 1) {
        result += ', ';
      }
    }

    result += ']';

    return result;
  }
}
