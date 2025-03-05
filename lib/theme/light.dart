import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36))),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 44,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.poppins(
          fontSize: 24.0, fontWeight: FontWeight.w400, color: Colors.white),
      headlineSmall: GoogleFonts.poppins(fontSize: 18.0, color: Colors.white),
      labelMedium: GoogleFonts.poppins(fontSize: 16.0, color: Colors.black),
      labelSmall: GoogleFonts.poppins(fontSize: 14.0, color: Colors.black),
      bodySmall: GoogleFonts.poppins(fontSize: 16.0, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade200,
        foregroundColor: Colors.white,
        shadowColor: Colors.blue,
        padding: const EdgeInsets.all(26),
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
    ),
  );
}

var pagePadding = const EdgeInsets.fromLTRB(26, 100, 26, 26);

var markdownStyleSheetWhite = MarkdownStyleSheet(
  h1: GoogleFonts.poppins(
    // Heading 1
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  h2: GoogleFonts.poppins(
    // Heading 2
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  h3: GoogleFonts.poppins(
    // Heading 3
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  p: GoogleFonts.poppins(
    // Paragraph
    fontSize: 16.0,
    color: Colors.white,
  ),
  strong: const TextStyle(
    // Bold text
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  em: const TextStyle(
    // Italic text
    fontStyle: FontStyle.italic,
    color: Colors.white,
  ),
  a: const TextStyle(
    // Link
    color: Colors.blue,
    decoration: TextDecoration.underline,
  ),
  code: GoogleFonts.robotoMono(
    // Code block
    backgroundColor: Colors.grey[800],
    color: Colors.white,
  ),
  blockquote: const TextStyle(
    // Blockquote
    color: Colors.grey,
    fontStyle: FontStyle.italic,
  ),
  listBullet: const TextStyle(
    // Unordered list
    color: Colors.white,
  ),
  blockSpacing: 24.0, // Spacing between blocks
);

var markdownStyleSheetBlack = MarkdownStyleSheet(
  h1: GoogleFonts.poppins(
    // Heading 1
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
  h2: GoogleFonts.poppins(
    // Heading 2
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
  h3: GoogleFonts.poppins(
    // Heading 3
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
  p: GoogleFonts.poppins(
    // Paragraph
    fontSize: 14.0,
    color: Colors.black,
  ),
  strong: const TextStyle(
    // Bold text
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
  em: const TextStyle(
    // Italic text
    fontStyle: FontStyle.italic,
    color: Colors.black,
  ),
  a: const TextStyle(
    // Link
    color: Colors.blue,
    decoration: TextDecoration.underline,
  ),
  code: GoogleFonts.robotoMono(
    // Code block
    backgroundColor: Colors.grey[800],
    color: Colors.black,
  ),
  blockquote: const TextStyle(
    // Blockquote
    color: Colors.grey,
    fontStyle: FontStyle.italic,
  ),
  listBullet: const TextStyle(
    // Unordered list
    color: Colors.black,
  ),
  blockSpacing: 24.0, // Spacing between blocks
);

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
