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

BoxDecoration gradientDeco() {
  return const BoxDecoration(
      gradient: LinearGradient(
          transform: GradientRotation(0.4),
          stops: [0.005, 0.3, 0.9],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(240, 255, 86, 34),
            Color.fromARGB(240, 56, 50, 109),
            Color.fromARGB(240, 155, 39, 176)
          ]));
}
