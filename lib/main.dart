import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/signin/welcome.dart';
import 'package:taskbuddy/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  // Add a custom splash screen so we can manually remove it
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();

    // Initialize the app
    init();
  }

  void init() async {
    // Change the status bar and navigation bar colors on Android
    overrideColors();

    // Check if logged in
    _loggedIn = await AccountCache.isLoggedIn();

    // Re-render the UI
    setState(() {});

    // Remove the splash screen after initialization
    FlutterNativeSplash.remove();
  }

  void overrideColors() {
    if (Platform.isAndroid) {
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
          statusBarIconBrightness: brightness));

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: [SystemUiOverlay.top]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        colorScheme: const ColorScheme(
          background: Constants.bgColor,
          brightness: Brightness.dark,
          primary: Constants.primaryColor,
          secondary: Constants.secondaryColor,
          surface: Constants.secondaryBgColor,
          error: Colors.red,
          onPrimary: Colors.black,
          onSecondary: Color(0xff000000),
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Color(0xff000000),
        ),
        useMaterial3: true,
      ),
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        colorScheme: const ColorScheme(
          background: Colors.white,
          brightness: Brightness.dark,
          primary: Constants.primaryColor,
          secondary: Constants.secondaryColor,
          surface: Constants.secondaryBgColor,
          error: Colors.red,
          onPrimary: Colors.black,
          onSecondary: Color(0xff000000),
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Color(0xff000000),
        ),
        useMaterial3: true,
      ),
      // If logged in, show the home screen, otherwise show the welcome screen
      home: _loggedIn ? const Scaffold() : const WelcomeScreen(),
    );
  }
}
