import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zen/auth_pages/auth_page.dart';

class LandPage extends StatelessWidget {
  const LandPage({super.key});

  void logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
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
      body: const Center(
          child: Text(
        "WELCOME TO ZENUNNI",
        style: TextStyle(fontSize: 24, color: Colors.amber),
      )),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 10,
            right: 90,
            child: FloatingActionButton(
              heroTag: 'todo',
              onPressed: () {
                Navigator.pushNamed(context, '/todo');
              },
              child: const Icon(Icons.edit),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              heroTag: 'mood',
              onPressed: () {
                Navigator.pushNamed(context, '/mood');
              },
              child: const Icon(Icons.emoji_emotions_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
