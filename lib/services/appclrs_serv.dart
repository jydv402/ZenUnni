import 'package:zen/zen_barrel.dart';

class AppColors {
  final bool isDarkMode;
  AppColors(this.isDarkMode);

  final _light = LightColors();
  final _dark = DarkColors();

  Color get mdText => isDarkMode ? _dark.mdText : _light.mdText;
  Color get homeBgTxt => isDarkMode ? _dark.homeBgTxt : _light.homeBgTxt;
  Color get pillClr => isDarkMode ? _dark.pillClr : _light.pillClr;
  Color get toastBg => isDarkMode ? _dark.toastBg : _light.toastBg;
  Color get iconClr => isDarkMode ? _dark.iconClr : _light.iconClr;
}

// Light and Dark Colors
class LightColors {
  final Color mdText = const Color.fromRGBO(0, 0, 0, 1); //black
  final Color homeBgTxt = const Color.fromRGBO(245, 245, 245, 0.320);
  final Color pillClr = const Color.fromRGBO(224, 224, 224, 1); //gray 300
  final Color toastBg = const Color.fromRGBO(255, 255, 255, 1); //white
  final Color iconClr = const Color.fromRGBO(0, 0, 0, 1); //black
}

class DarkColors {
  final Color mdText = const Color.fromRGBO(255, 255, 255, 1); //white
  final Color homeBgTxt = const Color.fromRGBO(255, 255, 255, 0.080);
  final Color pillClr = const Color.fromRGBO(66, 66, 66, 1); //gray 800
  final Color toastBg = const Color.fromARGB(255, 23, 25, 27); // gray app bg
  final Color iconClr = const Color.fromRGBO(255, 255, 255, 1); //white
}

// Riverpod Provider for AppColors
final appColorsProvider = Provider<AppColors>(
  (ref) {
    final themeMode = ref.watch(themeProvider);
    return AppColors(themeMode == ThemeMode.dark);
  },
);
