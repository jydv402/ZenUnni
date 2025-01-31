import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zen/auth_pages/auth_page.dart';
import 'package:zen/screens/todo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => logoutUser(context),
                icon: const Icon(Icons.logout_outlined))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "WELCOME TO ZENUNNI",
                style: TextStyle(fontSize: 24, color: Colors.amber),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Todo()));
                },
                child: const Text("Go to to-do list page"),
              ),
            ],
          ),
        ));
  }
}
