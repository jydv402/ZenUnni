import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Light theme for the app
ThemeData get lightTheme {
  return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: const Color(0xFF121212), // Dark gray/black - adjust as needed
        onPrimary: Colors.white, // White/light gray text and icons
        secondary:
            const Color(0xFF9575CD), // Lavender/purple - adjust as needed
        onSecondary: Colors.white, // White text on secondary buttons
        surface: const Color(
            0xFF202124), // Lighter gray for surface elements - adjust as needed
        onSurface: Colors.black, // Dark text on surface elements
        error: Colors.red, // Standard red for errors
        onError: Colors.white, // White text on background
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(36))),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.poppins(
            fontSize: 38, fontWeight: FontWeight.w600, color: Colors.white),
        headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(fontSize: 18.0),
        bodySmall: TextStyle(fontSize: 14.0),
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
