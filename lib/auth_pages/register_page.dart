import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/theme/light.dart';

class RegisterPage extends ConsumerWidget {
  RegisterPage({super.key});

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  void displayMessageToUser(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  void registerUser(BuildContext context) async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //if passwords dont match
    if (_passwordController.text != _confirmPasswordController.text) {
      //pop loading circle
      Navigator.pop(context);
      //display error message
      displayMessageToUser("Passwords don't match!", context);
    } else {
      //if passwords do match
      //try creating the user
      try {
        //create the user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());

        if (context.mounted) {
          //pop loading circle
          Navigator.pop(context);

          //navigate to home page
          Navigator.pushReplacementNamed(context, '/username');
        }
        // Clear fields after successful registration
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          //pop loading circle
          Navigator.pop(context);
          //display error message
          displayMessageToUser(e.code, context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ListView(
        padding: pagePadding,
        children: [
          Text(
            "Register",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 40),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          const SizedBox(
            height: 10,
          ),
          Text.rich(
              TextSpan(text: "Already have an account? ", children: [
                TextSpan(
                    text: "Login",
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        //navigate to login page
                        Navigator.pushReplacementNamed(context, '/login');
                      })
              ]),
              style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
      floatingActionButton: fabButton(context, () {
        registerUser(context);
        FocusScope.of(context).unfocus();
      }, "Register", 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
