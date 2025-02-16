import 'package:flutter/material.dart';

Padding fabButton(onPressed, String label) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    ),
  );
}
