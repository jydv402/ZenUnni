import 'package:zen/zen_barrel.dart';

class AppColors {
  final bool isDarkMode;
  AppColors(this.isDarkMode);

  final _light = LightColors();
  final _dark = DarkColors();

  Color get mdText => isDarkMode ? _dark.mdText : _light.mdText;
  Color get pillClr => isDarkMode ? _dark.pillClr : _light.pillClr;
  Color get toastBg => isDarkMode ? _dark.toastBg : _light.toastBg;
  Color get iconClr => isDarkMode ? _dark.iconClr : _light.iconClr;
}

// Light and Dark Colors
class LightColors {
  final Color mdText = Colors.black;
  final Color pillClr = Colors.grey[300]!;
  final Color toastBg = Colors.white;
  final Color iconClr = Colors.black;
}

class DarkColors {
  final Color mdText = Colors.white;
  final Color pillClr = Colors.grey[800]!;
  final Color toastBg = Colors.black;
  final Color iconClr = Colors.white;
}

// Riverpod Provider for AppColors
final appColorsProvider = Provider<AppColors>(
  (ref) {
    final themeMode = ref.watch(themeProvider);
    return AppColors(themeMode == ThemeMode.dark);
  },
);
