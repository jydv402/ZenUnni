import 'package:flutter/material.dart';

// Light theme for the app
ThemeData get lightTheme {
  return ThemeData(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(36))),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w500),
        headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(fontSize: 14.0),
      ));
}

BoxDecoration gradientDeco() {
  return const BoxDecoration(
    gradient: LinearGradient(
      stops: [0.2, 0.5, 0.9],
      begin: Alignment.topCenter,
      end: Alignment.bottomLeft,
      colors: [
        // Color.fromARGB(30, 255, 63, 63),
        // Color.fromARGB(30, 234, 78, 130),
        // Color.fromARGB(30, 255, 193, 7)

        Color.fromARGB(40, 0, 17, 255),
        Color.fromARGB(40, 166, 0, 255),
        Color.fromARGB(40, 255, 0, 217),
      ],
    ),
  );
}
