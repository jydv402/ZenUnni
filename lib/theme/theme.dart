import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zen/theme/text_theme.dart';

// Light theme for the app
ThemeData get darkTheme {
  return ThemeData(
    //NOTE: Dark colorscheme
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: const Color.fromRGBO(238, 238, 238, 1), // Light gray
      onPrimary: Colors.black,
      secondary: const Color.fromRGBO(103, 58, 183, 1), // Darker purple
      onSecondary: Colors.white,
      surface: const Color.fromARGB(255, 23, 25, 27),
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: headLD,
      headlineMedium: headMD,
      headlineSmall: headSD,
      labelMedium: labelMD,
      labelSmall: labelSD,
      bodyMedium: bodyMD,
      bodySmall: bodySD,
      titleMedium: prfDivTxtD,
      titleLarge: counterD,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(255, 139, 44, 1),
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
        borderSide: const BorderSide(
            color: Color.fromRGBO(255, 139, 44, 1), width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      hintStyle: hintD,
      labelStyle: hintD,
      helperStyle: hintD,
      prefixStyle: hintD,
      suffixStyle: hintD,
      counterStyle: hintD,
      errorStyle: hintD.copyWith(color: Colors.red),
      floatingLabelStyle: hintD,
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
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(255, 139, 44, 1),
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
      backgroundColor: const Color.fromRGBO(32, 33, 36, 1),
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
          return const Color.fromRGBO(255, 139, 44, 1);
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
          return const Color.fromRGBO(255, 139, 44, 1);
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
          return const Color.fromRGBO(255, 139, 44, 1);
        }),
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return const Color.fromRGBO(255, 139, 44, 1);
        }),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
        dayPeriodTextStyle: headS,
        dayPeriodBorderSide: BorderSide(color: Colors.white),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return const Color.fromRGBO(255, 139, 44, 1);
          }),
        ),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return const Color.fromRGBO(255, 139, 44, 1);
          }),
        ),
        dayPeriodTextColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? const Color.fromARGB(255, 0, 0, 0)
              : const Color.fromARGB(255, 255, 255, 255),
        ),
        timeSelectorSeparatorColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey;
          }
          return Colors.white;
        }),
        hourMinuteTextColor: Color.from(alpha: 1, red: 1, green: 1, blue: 1),
        hourMinuteColor: Color.fromRGBO(255, 139, 44, 1),
        dialBackgroundColor:
            const Color.fromRGBO(32, 33, 36, 1), // Background color
        backgroundColor:
            const Color.fromRGBO(32, 33, 36, 1), // Background color
        dialHandColor: Color.fromRGBO(255, 139, 44, 1),
        dialTextColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : const Color.fromARGB(255, 255, 255, 255),
        ),
        entryModeIconColor: const Color.fromRGBO(255, 255, 255, 1),
        dayPeriodColor: const Color.fromRGBO(255, 255, 255, 1)),

    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(
          fontFamily: 'Pop',
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
      textStyle: TextStyle(
        fontFamily: 'Pop',
        fontSize: 16.0,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
    ),
  );
}

ThemeData get lightTheme {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color.fromRGBO(255, 139, 44, 1), // Orange
      onPrimary: Colors.white,
      secondary:
          const Color.fromRGBO(255, 165, 79, 1), // Lighter shade of orange
      onSecondary: Colors.white,
      surface: Colors.white, // Light background
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: headL,
      headlineMedium: headM,
      headlineSmall: headS,
      labelMedium: labelM,
      labelSmall: labelS,
      bodyMedium: bodyM,
      bodySmall: bodyS,
      titleMedium: prfDivTxt,
      titleLarge: counter,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 139, 44, 1),
        foregroundColor: Colors.white,
        shadowColor: Colors.orangeAccent,
        padding: const EdgeInsets.all(26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color.fromRGBO(255, 139, 44, 1);
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStatePropertyAll(Colors.black),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.black54;
        },
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Color.fromRGBO(255, 139, 44, 1);
          }
          return Colors.black54;
        },
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: Colors.transparent,
      //   statusBarIconBrightness: Brightness.dark,
      //   statusBarBrightness: Brightness.dark,
      // ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(32),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(
          color: Colors.black54,
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(
          color: Colors.black54,
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(
          color: Color.fromRGBO(255, 139, 44, 1),
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
      hintStyle: hint.copyWith(color: Colors.black54),
      labelStyle: hint,
      helperStyle: hint,
      prefixStyle: hint,
      suffixStyle: hint,
      counterStyle: hint,
      errorStyle: hint.copyWith(color: Colors.red),
      floatingLabelStyle: hint,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      labelTextStyle: WidgetStateProperty.all(bodyS),
      iconTheme: WidgetStateProperty.all(
        const IconThemeData(color: Colors.black),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      dayForegroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          } else if (states.contains(WidgetState.disabled)) {
            return Colors.grey;
          }
          return Colors.black;
        },
      ),
      dividerColor: Colors.black,
      yearForegroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.black;
        },
      ),
      yearStyle: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    timePickerTheme: const TimePickerThemeData(
      dayPeriodTextStyle: headS,
      hourMinuteTextColor: Color.fromRGBO(255, 255, 255, 1),
      hourMinuteColor: Color.fromRGBO(255, 139, 44, 1),
      backgroundColor: Colors.white,
      dialHandColor: Color.fromRGBO(255, 139, 44, 1),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      iconColor: Colors.black,
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(
          fontFamily: 'Pop',
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
      textStyle: TextStyle(
        fontFamily: 'Pop',
        fontSize: 16.0,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
    ),
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
    fontFamily: 'Pop',
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
  em: const TextStyle(
    // Italic text
    fontFamily: 'Pop',
    fontStyle: FontStyle.italic,
    color: Colors.black,
  ),
  a: const TextStyle(
    // Link
    fontFamily: 'Pop',
    color: Colors.blue,
    decoration: TextDecoration.underline,
  ),
  code: GoogleFonts.robotoMono(
    // Code block
    backgroundColor: Colors.white,
    color: Colors.black,
  ),
  blockquote: const TextStyle(
    // Blockquote
    fontFamily: 'Pop',
    color: Colors.grey,
    fontStyle: FontStyle.italic,
  ),
  listBullet: const TextStyle(
    // Unordered list
    fontFamily: 'Pop',
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
