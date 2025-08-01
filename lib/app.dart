import 'package:flutter/material.dart';

/// MyApp is the root widget of the entire application.
/// It sets up the theme, routes, and the home screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO App',
      debugShowCheckedModeBanner: false,

      // 🌗 Theme for the whole app
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
        ),
      ),

      // 🏠 Home screen (I will define HomeScreen later)
      home: const Placeholder(), // TODO: Replace with HomeScreen()
    );
  }
}
