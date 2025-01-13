import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        "WELCOME TO ZENUNNI",
        style: TextStyle(fontSize: 24, color: Colors.amber),
      )),
    );
  }
}
