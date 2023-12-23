import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/create_post/pages/create_post_screen.dart';
import 'package:taskbuddy/screens/create_post/pages/date_and_price.dart';
import 'package:taskbuddy/screens/create_post/pages/location_page.dart';
import 'package:taskbuddy/screens/create_post/pages/media_page.dart';
import 'package:taskbuddy/screens/create_post/pages/post_overview.dart';
import 'package:taskbuddy/screens/create_post/pages/tags_page.dart';
import 'package:taskbuddy/screens/create_post/pages/title_page.dart';
import 'package:taskbuddy/screens/home/home_screen.dart';
import 'package:taskbuddy/screens/home/pages/profile/edit/profile_edit.dart';
import 'package:taskbuddy/screens/post_screen.dart';
import 'package:taskbuddy/screens/settings/account/account_settings.dart';
import 'package:taskbuddy/screens/settings/appearance/appearance_settings.dart';
import 'package:taskbuddy/screens/settings/appearance/appearance_theme.dart';
import 'package:taskbuddy/screens/settings/settings.dart';
import 'package:taskbuddy/screens/signin/register/pages/profile_details_page.dart';
import 'package:taskbuddy/screens/signin/register/pages/profile_finish_page.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/state/providers/preferences.dart';
import 'package:taskbuddy/screens/signin/login/login_screen.dart';
import 'package:taskbuddy/screens/signin/register/pages/credentials_page.dart';
import 'package:taskbuddy/screens/signin/register/register_screen.dart';
import 'package:taskbuddy/screens/signin/welcome/welcome_screen.dart';
import 'package:taskbuddy/state/providers/tags.dart';
import 'package:taskbuddy/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/utils/initializers.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/screens/location_input/location_input.dart';
import 'package:taskbuddy/widgets/transitions/slide_in.dart';

void main() {
  // Add a custom splash screen so we can manually remove it
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PreferencesModel()),
        ChangeNotifierProvider(create: (context) => AuthModel()),
        ChangeNotifierProvider(create: (context) => TagModel()),
      ],
      child: const App(),
    )
  );
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
    bodyLarge: const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    bodyMedium: const TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    bodySmall: GoogleFonts.montserrat(
      fontSize: 12,
      color: Colors.grey[500],
    ),
    displaySmall: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.grey[500],
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      color: Colors.grey[500],
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      color: Colors.grey[500],
    ),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize the app after the first frame is rendered
      init();
    });
  }

  void init() async {
    // Check if logged in
    _loggedIn = await AccountCache.isLoggedIn();

    // Initialize the cache
    await Initializers.initCache(context);

    // Re-render the UI
    setState(() {});

    // Remove the splash screen after initialization
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    // Change the status bar and navigation bar colors on Android
    Utils.overrideColors();

    // Lock the orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return OverlaySupport.global(
      child: Consumer<PreferencesModel>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            title: 'TaskBuddy',
            themeMode: value.themeMode,
            // Set the scroll behavior to the platform default
            scrollBehavior: Platform.isAndroid
                ? const MaterialScrollBehavior()
                : const CupertinoScrollBehavior(),
            darkTheme: ThemeData(
              textTheme: _textTheme,
              fontFamily: GoogleFonts.montserrat().fontFamily,
              sliderTheme: const SliderThemeData(
                showValueIndicator: ShowValueIndicator.always
              ),
              colorScheme: ColorScheme(
                background: Constants.bgColor,
                brightness: Brightness.dark,
                primary: Constants.primaryColor,
                inversePrimary: Constants.primaryColor,
                inverseSurface: Colors.black,
                secondary: Constants.secondaryColor,
                surface: const Color(0xff322B44),
                surfaceVariant: Constants.secondaryBgColor.withOpacity(0.7),
                onSurfaceVariant: Colors.grey[500],
                error: Colors.red,
                onPrimary: Colors.black,
                onSecondary: const Color(0xff000000),
                onSurface: Colors.white,
                onBackground: Colors.white,
                onError: Colors.white,
                outline: Constants.borderColor,
                shadow: Colors.black.withOpacity(0.8),
              ),
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: SlideTransitionBuilder(),
                TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
              }),
              useMaterial3: true,
            ),
            theme: ThemeData(
              fontFamily: GoogleFonts.montserrat().fontFamily,
              sliderTheme: const SliderThemeData(
                showValueIndicator: ShowValueIndicator.always
              ),
              colorScheme: ColorScheme(
                background: Colors.white,
                brightness: Brightness.dark,
                primary: Constants.primaryColorLight,
                inversePrimary: Colors.blue, // This is the link color
                secondary: Constants.secondaryColor,
                inverseSurface: Colors.white,
                surface: Color.fromARGB(255, 236, 236, 236),
                surfaceVariant: Color.fromARGB(255, 224, 224, 224).withOpacity(0.6),
                onSurfaceVariant: Colors.grey[600],
                error: Colors.red,
                onPrimary: Colors.white,
                onSecondary: Colors.black,
                onSurface: Colors.black,
                onBackground: Colors.black,
                onError: Colors.white, // Color that is used for error messages (text)
                outline: Color.fromARGB(255, 156, 144, 184),
                shadow: Colors.black.withOpacity(0.5),
              ),
              textTheme: _textTheme.copyWith(
                titleLarge: _textTheme.titleLarge!.copyWith(
                  color: Colors.black,
                ),
                titleMedium: _textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                ),
                titleSmall: _textTheme.titleSmall!.copyWith(
                  color: Colors.black,
                ),
                bodyLarge: _textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                ),
                bodyMedium: _textTheme.bodyMedium!.copyWith(
                  color: Colors.black,
                ),
                bodySmall: _textTheme.bodySmall!.copyWith(
                  color: Colors.grey[600],
                ),
                displaySmall: _textTheme.displaySmall!.copyWith(
                  color: Colors.grey[600],
                ),
                labelMedium: _textTheme.labelMedium!.copyWith(
                  color: Colors.grey[600],
                ),
                labelLarge: _textTheme.labelLarge!.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: SlideTransitionBuilder(),
                TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
              }),
              useMaterial3: true,
            ),
            // If logged in, show the home screen, otherwise show the welcome screen
            home: _loggedIn ? const HomeScreen() : const WelcomeScreen(),
            routes: {
              '/welcome': (context) => const WelcomeScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/register/creds': (context) => const CredentialsPage(),
              '/register/profile/details': (context) => const ProfileDetailsPage(),
              '/register/profile/finish': (context) => const ProfileFinishPage(),
              '/settings': (context) => const SettingsScreen(),
              '/settings/account': (context) => const AccountSettings(),
              '/settings/appearance': (context) => const AppearanceSettings(),
              '/settings/appearance/theme': (context) => const AppearanceThemeSetting(),
              '/create-post': (context) => const CreatePostScreen(),
              '/create-post/location': (context) => const CreatePostLocation(),
              '/create-post/title': (context) => const CreatePostTitle(),
              '/create-post/media': (context) => const CreatePostMedia(),
              '/create-post/date-price': (context) => const CreatePostDatePrice(),
              '/create-post/tags': (context) => const CreatePostTagsPage(),
              '/create-post/overview': (context) => const CreatePostOverviewPage(),
              '/home': (context) => const HomeScreen(),
              '/profile/edit': (context) => const ProfileEditScreen(),
              '/location-chooser': (context) => const LocationInputScreen(),
              '/post': (context) => const PostScreen(),
            },
            localeListResolutionCallback: (__, supportedLocales) {
              // If the locale is supported, return it
              for (Locale supportedLocale in supportedLocales) {
                if (Platform.localeName.split('_')[0].toLowerCase() == supportedLocale.languageCode) {
                  return supportedLocale;
                }
              }
              
              return const Locale('en', 'US'); // Default to English
            },
            onGenerateRoute: (settings) {
              // Override status bar color on route change
              Utils.overrideColors();
              
              return null;
            },
            builder: (context, child) {
              // Override colors
              Utils.overrideColors();

              return child ?? Container();
            }
          );
        },
      ),
    );
  }
}
