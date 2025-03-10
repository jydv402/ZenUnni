import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/zen_barrel.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void logoutUser(BuildContext context, WidgetRef ref) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      // Navigate to the root page after logging out
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(userNameProvider);
    return Hero(
      tag: 'profile',
      child: Material(
        type: MaterialType.transparency,
        child: Scaffold(
          body: ListView(
            padding: pagePaddingWithScore,
            children: [
              ScoreCard(),
              Text(
                "Profile",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 100,
              ),
              Text(
                username.value ?? 'No username',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 26,
              ),
              fabButton(context, () {
                Navigator.pushNamed(context, '/username');
              }, "Change username", 0),
              const SizedBox(
                height: 110,
              ),
              fabButton(context, () {
                // show logout dialog
                showConfirmDialog(
                    context,
                    "Logout ?",
                    "Are you sure you want to logout ?",
                    "Logout",
                    Colors.red, () {
                  logoutUser(context, ref); // Pass ref here
                  Navigator.of(context).pop();
                });
              }, "Logout", 0),
            ],
          ),
        ),
      ),
    );
  }
}
