import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zen/pages/auth_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => logoutUser(context),
              icon: Icon(Icons.logout_outlined)
          )
        ],
      ),
      body: Center(
          child: Text(
        "WELCOME TO ZENUNNI",
        style: TextStyle(fontSize: 24, color: Colors.amber),
      )),
    );
  }
}
