import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/zen_barrel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obsureText = true;
  bool _isLoading = false;

  void _toggleObscure() {
    setState(() {
      _obsureText = !_obsureText;
    });
  }

  void loginUser() async {
    if (_isLoading) return; // Prevent multiple attempts

    try {
      setState(() => _isLoading = true);
      stateInvalidator(ref);

      showLoadingDialog(context, "Logging you in...");

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        Navigator.pushReplacementNamed(context, '/nav');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
            "Login",
            style: headL,
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
        loginUser();
      }, 'Login', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
