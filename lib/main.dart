import 'package:flutter/material.dart';
import 'package:taskbuddy/util/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
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
      body: const Center(
        child: Text(
          'Hello, world!',
        ),
      ),
    );
  }
}
