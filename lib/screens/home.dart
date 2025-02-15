import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        style:
            TextStyle(fontSize: 24, color: Color.fromARGB(255, 28, 224, 246)),
      )),
      floatingActionButton: Stack(
        children: [
          // Floating Action Button for MoodPage
          pageButtons(context, 'mood', '/mood1',
              Icon(Icons.emoji_emotions_rounded), 10, 10),
          // Floating Action Button for TodoPage
          pageButtons(
              context, 'todo', '/todo', Icon(Icons.edit_rounded), 10, 90),
          //FAB for chat page
          pageButtons(context, 'chat', '/chat',
              Icon(Icons.content_paste_go_rounded), 90, 90),
          //Pomodoro Button
          pageButtons(
              context, 'pomo', '/pomo', Icon(Icons.timer_rounded), 90, 10),
        ],
      ),
    );
  }

  Widget pageButtons(BuildContext context, String heroTag, String route,
      Icon icon, double bottom, double right) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: icon,
      ),
    );
  }
}
