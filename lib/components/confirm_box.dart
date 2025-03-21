import 'package:flutter/material.dart';

void showConfirmDialog(
  BuildContext context,
  String title,
  String msg,
  String action,
  Color actionClr,
  VoidCallback onPressed,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        content: Text(
          msg,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child:
                Text("Cancel", style: Theme.of(context).textTheme.bodyMedium),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              action,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: actionClr),
            ),
          ),
        ],
      );
    },
  );
}
