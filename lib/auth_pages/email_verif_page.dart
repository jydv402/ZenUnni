import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zen/zen_barrel.dart';

class EmailVerifPage extends ConsumerStatefulWidget {
  const EmailVerifPage({super.key});

  @override
  ConsumerState<EmailVerifPage> createState() => _EmailVerifPageState();
}

class _EmailVerifPageState extends ConsumerState<EmailVerifPage> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    checkEmailVerification();
    timer = Timer.periodic(
      Duration(seconds: 3),
      (_) => checkEmailVerification(),
    );
  }

  Future<void> checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      setState(() => isEmailVerified = true);
      timer?.cancel();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const UsernamePage(
              isUpdate: false,
            ),
          ),
        );
      }
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      if (mounted) {
        showHeadsupNoti(context, "Verification email resent!");
      }
    } catch (e) {
      if (mounted) {
        showHeadsupNoti(context, "Error: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: pagePadding,
        children: [
          const Text(
            'Verify Your Email',
            style: headL,
          ),
          SizedBox(height: 20),
          Text(
            "We've sent a verification email. Please check your inbox and follow the instructions to continue.",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 40),
          fabButton(
              context, () => resendVerificationEmail(), "Resend Email", 0),
          SizedBox(height: 10),
          fabButton(context, () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/register');
          }, "Change Email", 0)
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
