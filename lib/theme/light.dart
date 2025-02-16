import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Light theme for the app
ThemeData get lightTheme {
  return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: const Color(0xFF121212),
        onPrimary: Colors.white,
        secondary: const Color(0xFF9575CD),
        onSecondary: Colors.white,
        surface: const Color(0xFF202124),
        onSurface: Colors.black,
        error: Colors.red,
        onError: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(36))),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.poppins(
            fontSize: 38, fontWeight: FontWeight.w600, color: Colors.white),
        headlineMedium:
            GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.w400),
        headlineSmall: GoogleFonts.poppins(fontSize: 18.0),
        bodySmall: GoogleFonts.poppins(fontSize: 14.0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shadowColor: Colors.blue,
          padding: EdgeInsets.all(26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          //Define the status bar parameters
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
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
