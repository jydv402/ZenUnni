import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandPage extends StatelessWidget {
  const LandPage({super.key});

  // Function to log out the user
  void logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      // Navigate to the root page after logging out
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Logout button in the app bar
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
          // Floating Action Button for TodoPage
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
          // Floating Action Button for MoodPage
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              heroTag: 'mood',
              onPressed: () {
                Navigator.pushNamed(context, '/mood1');
              },
              child: const Icon(Icons.emoji_emotions_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
