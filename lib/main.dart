import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/signin/login/login_screen.dart';
import 'package:taskbuddy/screens/signin/welcome/welcome_screen.dart';
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

  final TextTheme _textTheme = GoogleFonts.montserratTextTheme().copyWith(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w900,
      color: Colors.white,
      // On iOS, the font family is 'SF Pro Display' by default
      // On Android, the font family is 'Montserrat'
      fontFamily: Constants.getHeadingFontFamily(),
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w900,
      color: Colors.white,
      fontFamily: Constants.getHeadingFontFamily(),
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w900,
      color: Colors.white,
      fontFamily: Constants.getHeadingFontFamily(),
    ),
    bodyMedium: const TextStyle(
      color: Colors.white,
    ),
  );

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
        scrollBehavior: Platform.isAndroid
            ? const MaterialScrollBehavior()
            : const CupertinoScrollBehavior(),
        darkTheme: ThemeData(
          textTheme: _textTheme,
          fontFamily: GoogleFonts.montserrat().fontFamily,
          colorScheme: ColorScheme(
            background: Constants.bgColor,
            brightness: Brightness.dark,
            primary: Constants.primaryColor,
            secondary: Constants.secondaryColor,
            surface: Constants.secondaryBgColor,
            surfaceVariant: Constants.secondaryBgColor.withOpacity(0.7),
            error: Colors.red,
            onPrimary: Colors.white,
            onSecondary: const Color(0xff000000),
            onSurface: Colors.white,
            onBackground: Colors.white,
            onError: const Color(0xff000000),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
          useMaterial3: true,
        ),
        theme: ThemeData(
          fontFamily: GoogleFonts.montserrat().fontFamily,
          colorScheme: const ColorScheme(
            background: Colors.white,
            brightness: Brightness.dark,
            primary: Constants.primaryColor,
            secondary: Constants.secondaryColor,
            surface: Color(0xFFDBDBDB),
            error: Colors.red,
            onPrimary: Colors.black,
            onSecondary: Color(0xff000000),
            onSurface: Colors.black,
            onBackground: Colors.black,
            onError: Color(0xff000000),
          ),
          textTheme: _textTheme.copyWith(
            titleLarge: const TextStyle(
              color: Colors.black,
            ),
            titleMedium: const TextStyle(
              color: Colors.black,
            ),
            titleSmall: const TextStyle(
              color: Colors.black,
            ),
            bodyMedium: const TextStyle(
              color: Colors.black,
            ),
          ),
          useMaterial3: true,
        ),
        // If logged in, show the home screen, otherwise show the welcome screen
        home: _loggedIn ? const Scaffold() : const WelcomeScreen(),
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
        });
  }
}
