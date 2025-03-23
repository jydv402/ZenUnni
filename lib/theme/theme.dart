import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zen/theme/text_theme.dart';

// Light theme for the app
ThemeData get darkTheme {
  return ThemeData(
    //NOTE: Dark colorscheme
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFEEEEEE), // Light gray
      onPrimary: Colors.black,
      secondary: const Color(0xFF673AB7), // Darker purple
      onSecondary: Colors.white,
      surface: const Color.fromARGB(255, 23, 25, 27),
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 44,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18.0,
        color: Colors.white,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 16.0,
        color: Colors.black,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 14.0,
        color: Colors.black,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 16.0,
        color: Colors.white,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 13.0,
        color: Colors.white,
      ),
      titleMedium: prfDivTxtD,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF8B2C),
        foregroundColor: Colors.white,
        shadowColor: Colors.orangeAccent,
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
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(32),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: Colors.white, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: Colors.white, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: Color(0xFFFF8B2C), width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      hintStyle: GoogleFonts.poppins(fontSize: 16.0, color: Colors.white),
      labelStyle: GoogleFonts.poppins(fontSize: 16.0, color: Colors.white),
      helperStyle: GoogleFonts.poppins(fontSize: 16.0, color: Colors.white),
      prefixStyle: GoogleFonts.poppins(fontSize: 16.0, color: Colors.white),
      suffixStyle: GoogleFonts.poppins(fontSize: 16.0, color: Colors.white),
      counterStyle: GoogleFonts.poppins(fontSize: 16.0, color: Colors.white),
      errorStyle: GoogleFonts.poppins(fontSize: 16.0, color: Colors.red),
      floatingLabelStyle:
          GoogleFonts.poppins(fontSize: 16.0, color: Colors.white),
    ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: WidgetStateProperty.all(bodySD),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.black);
          }
          return const IconThemeData(color: Colors.white);
        },
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStatePropertyAll(
          BorderSide(color: Colors.white),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return const Color.fromRGBO(255, 139, 44, 1);
            }
            return Colors.transparent;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.black;
            }
            return Colors.white;
          },
        ),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      // rangePickerBackgroundColor: Color(0xFF202124),
      // rangePickerHeaderBackgroundColor: Color(0xFF202124),
      // rangePickerShadowColor: Color(0xFF202124),

      //
      rangePickerHeaderForegroundColor: Colors.white,
      headerForegroundColor: Colors.white,
      backgroundColor: const Color(0xFF202124),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.black;
        } else if (states.contains(WidgetState.disabled)) {
          return Colors.grey;
        }
        return Colors.white;
      }),

      dayBackgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFFff8b2c);
        }
        return Colors.transparent;
      }),
      dividerColor: Colors.white,
      headerHeadlineStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      weekdayStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 18,
      ),
      dayStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 16,
      ),
      yearBackgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFFff8b2c);
        }
        return Colors.transparent;
      }),

      yearForegroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return const Color.fromRGBO(0, 0, 0, 1);
          }
          return const Color.fromARGB(255, 255, 255, 255);
        },
      ),
      yearStyle: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white,
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return const Color(0xFFff8b2c);
        }),
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return const Color(0xFFff8b2c);
        }),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
        dayPeriodBorderSide: BorderSide(color: Colors.white),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return const Color(0xFFff8b2c);
          }),
        ),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return const Color(0xFFff8b2c);
          }),
        ),
        dayPeriodTextColor: Color.fromRGBO(0, 0, 0, 1),
        timeSelectorSeparatorColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey;
          }
          return Colors.white;
        }),
        hourMinuteTextColor: Color(0xFFFfffff),
        hourMinuteColor: Color(0xFFff8b2c),
        dialBackgroundColor: const Color(0xFF202124), // Background color
        backgroundColor: const Color(0xFF202124), // Background color
        dialHandColor: Color(0xFFFF8B2C),
        dialTextColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : const Color.fromARGB(255, 255, 255, 255),
        ),
        entryModeIconColor: const Color(0xFFffffff),
        dayPeriodColor: const Color(0xFFFFffff)),
  );
}

var pagePadding = const EdgeInsets.fromLTRB(26, 100, 26, 26);
var pagePaddingWithScore = const EdgeInsets.fromLTRB(26, 50, 26, 26);

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
