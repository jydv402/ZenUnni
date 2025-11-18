import 'package:flutter/material.dart';

Color getColorFromHex(String hexColor) {
  if (hexColor.startsWith("#")) {
    hexColor = hexColor.substring(1); // Remove "#" if present
  }

  if (hexColor.length == 8) { 
    return Color(
      int.parse("0x$hexColor"),
    ); // ARGB format
  } else if (hexColor.length == 6) {
    return Color(
      int.parse("0xFF$hexColor"),
    ); // RGB format, add full opacity
  } else {
    return Colors.black; // Default color to prevent crashes
  }
}
