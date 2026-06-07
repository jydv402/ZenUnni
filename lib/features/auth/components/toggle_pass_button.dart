import 'package:zen/zen_barrel.dart';

Widget togglePassButton(VoidCallback onPressed, bool obsureText, Color color) =>
    IconButton(
      tooltip: "Toggle password visibility",
      padding: EdgeInsets.only(right: 26),
      onPressed: onPressed,
      icon: Icon(
        obsureText ? LucideIcons.eye_closed : LucideIcons.eye,
        color: color,
      ),
      highlightColor: Colors.transparent,
    );
