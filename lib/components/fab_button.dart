import 'package:flutter/material.dart';

Padding fabButton(onPressed, String label, double pad) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: pad),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    ),
  );
}
