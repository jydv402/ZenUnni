import 'package:flutter/material.dart';

// Light theme for the app
ThemeData get lightTheme {
  return ThemeData(
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          shape: CircleBorder(), elevation: 4),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w500),
        headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(fontSize: 14.0),
      ));
}
