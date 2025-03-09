import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/zen_barrel.dart';

class PassResetPage extends ConsumerStatefulWidget {
  const PassResetPage({super.key});

  @override
  ConsumerState<PassResetPage> createState() => _PassResetPageState();
}

class _PassResetPageState extends ConsumerState<PassResetPage> {
  final resetEmailController = TextEditingController();

  @override
  void dispose() {
    resetEmailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetEmailController.text.trim());
      if (mounted) {
        showConfirmDialog(
          context,
          "Password Reset",
          "Password reset link sent!\ncheck your email",
          "Okay",
          Colors.green.shade200,
          () {
            Navigator.pop(context);
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        showConfirmDialog(
          context,
          "Error",
          "Error sending reset link: ${e.code}",
          "Retry",
          Colors.red,
          () {
            passwordReset();
            Navigator.pop(context);
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: resetEmailContainer(context),
      floatingActionButton:
          fabButton(context, () => passwordReset(), 'Reset Password', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget resetEmailContainer(context) {
    return ListView(
      padding: pagePadding,
      children: [
        Text(
          "Forgot Your Password?",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 10),
        Text(
          "Enter your email and we'll send you a reset link",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 40),
        TextField(
          controller: resetEmailController,
          style: Theme.of(context).textTheme.bodyMedium,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Enter your email',
          ),
        ),
      ],
    );
  }
}
