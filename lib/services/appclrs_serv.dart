import 'package:zen/zen_barrel.dart';

class AppColors {
  final bool isDarkMode;
  AppColors(this.isDarkMode);

  final _light = LightColors();
  final _dark = DarkColors();

  Color get toastBg => isDarkMode ? _dark.toastBg : _light.toastBg;
  Color get toastText => isDarkMode ? _dark.toastText : _light.toastText;
}

// Light and Dark Colors
class LightColors {
  final Color toastBg = Colors.white;
  final Color toastText = Colors.black;
}

class DarkColors {
  final Color toastBg = Colors.black;
  final Color toastText = Colors.white;
}

// Riverpod Provider for AppColors
final appColorsProvider = Provider<AppColors>(
  (ref) {
    final themeMode = ref.watch(themeProvider);
    return AppColors(themeMode == ThemeMode.dark);
  },
);
