import 'package:flutter/material.dart';

// Light theme for the app
ThemeData get lightTheme {
  return ThemeData(
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.black,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.white),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          shape: CircleBorder(), elevation: 4),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w500),
        headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(fontSize: 14.0),
      ));
}
