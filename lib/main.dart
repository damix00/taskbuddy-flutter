import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbuddy/util/constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


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
      home: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('latinary fanboy', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.helloWorld,
        ),
      ),
    );
  }
}
