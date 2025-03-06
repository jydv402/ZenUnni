import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/components/confirm_box.dart';
import 'package:zen/components/fab_button.dart';
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
          fabButton(context, () {
            // show logout dialog
            showConfirmDialog(context, "Logout ?",
                "Are you sure you want to logout ?", "Logout", () {
              logoutUser(context);
              Navigator.of(context).pop();
            });
          }, "Logout", 0),
        ],
      ),
    );
  }
}
