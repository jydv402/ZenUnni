import 'package:zen/zen_barrel.dart';

Widget toggleThemeButton(VoidCallback onPressed, bool themeMode, Color color) =>
    IconButton(
      tooltip: "Toggle theme",
      onPressed: onPressed,
      icon: Icon(
        themeMode ? LucideIcons.sun : LucideIcons.moon,
        color: color,
      ),
    );
