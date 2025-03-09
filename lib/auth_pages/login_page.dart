import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/components/confirm_box.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/theme/light.dart';
import 'package:zen/utils/state_invalidator.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obsureText = true;

  void displayMessageToUser(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  void _toggleObscure() {
    setState(() {
      _obsureText = !_obsureText;
    });
  }

  void loginUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      // pop loading circle
      if (mounted) {
        Navigator.pop(context);
        // navigate to home page
        Navigator.pushReplacementNamed(
          context,
          '/home',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        // pop loading circle
        Navigator.pop(context);
        showConfirmDialog(
            context, "Error", e.code.replaceAll("-", " "), "Retry", Colors.red,
            () {
          Navigator.pop(context);
          _passwordController.clear();
          setState(() {
            _obsureText = true;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: pagePadding,
        children: [
          Text(
            "Login",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 40,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                padding: const EdgeInsets.only(right: 26),
                onPressed: _toggleObscure,
                icon: Icon(
                  _obsureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white,
                ),
                highlightColor: Colors.transparent,
              ),
            ),
            obscureText: _obsureText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              text: "Forgot Password?",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // navigate to password reset page
                  Navigator.pushNamed(context, '/pass_reset');
                },
            ),
          ),
          const SizedBox(height: 60),
          Text.rich(
            TextSpan(
              text: "Don't have an account? ",
              children: [
                TextSpan(
                    text: "Register",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // navigate to register page
                        Navigator.pushReplacementNamed(context, '/register');
                      })
              ],
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 200),
        ],
      ),
      floatingActionButton: fabButton(context, () {
        stateInvalidator(ref);
        loginUser();
      }, 'Login', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
