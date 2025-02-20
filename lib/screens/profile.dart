import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/theme/light.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      // Navigate to the root page after logging out
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ListView(
        padding: pagePadding,
        children: [
          Text(
            "Profile",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 100,
          ),
          ElevatedButton(
              onPressed: () => _showdialog(),
              child: Text("Logout",
                  style: Theme.of(context).textTheme.headlineSmall))
        ],
      ),
    );
  }

  AlertDialog _showdialog() {
    return AlertDialog(
      actions: [Text("Are you sure you want to logout?")],
    );
  }
}
