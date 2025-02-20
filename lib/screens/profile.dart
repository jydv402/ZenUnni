import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
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
              onPressed: () => _showLogoutDialog(context),
              child: Text("Logout",
                  style: Theme.of(context).textTheme.headlineSmall))
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          title: Text(
            "Logout ?",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          content: Text(
            "Are you sure you want to logout?",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child:
                  Text("Cancel", style: Theme.of(context).textTheme.bodySmall),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                logoutUser(context); // Call the logout function
              },
              child: Text(
                "Logout",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
