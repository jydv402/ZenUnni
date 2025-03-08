import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/theme/light.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends ConsumerState<RegisterPage> {
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

  Future<void> registerUser(BuildContext context) async {
  // Show loading indicator
  showDialog(
    context: context,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  // Check if passwords match
  if (_passwordController.text != _confirmPasswordController.text) {
    Navigator.pop(context);
    displayMessageToUser("Passwords don't match!", context);
    return;
  }

  try {
    final auth = FirebaseAuth.instance;
    final email = _emailController.text.trim();

    // Check if email is already registered
    final signInMethods = await auth.fetchSignInMethodsForEmail(email);

    if (signInMethods.isNotEmpty) {
      // If the email is registered, check if the account is verified
      final user = auth.currentUser;

      if (user != null && user.email == email && !user.emailVerified) {
        // If user exists and is NOT verified, delete the account
        await user.delete();
        await auth.signOut(); // Ensure no active session
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          displayMessageToUser("Email already in use. Please log in.", context);
          return;
        }
      }
    }

    // Create a new user
    UserCredential userCredential =
        await auth.createUserWithEmailAndPassword(email: email, password: _passwordController.text.trim());

    // Send verification email
    await userCredential.user?.sendEmailVerification();

    if (context.mounted) {
      Navigator.pop(context);
      // Navigate to Email Verification Page
      Navigator.pushReplacementNamed(context, '/email_verif');
    }

    // Clear input fields
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  } on FirebaseAuthException catch (e) {
    if (context.mounted) {
      Navigator.pop(context);
      displayMessageToUser(e.message ?? "An error occurred", context);
    }
  }
}



  bool _obsureText = true;

  void _toggleObscure() {
    setState(() {
      _obsureText = !_obsureText;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                padding: EdgeInsets.only(right: 26),
                onPressed: () => _toggleObscure(),
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
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              suffixIcon: IconButton(
                padding: EdgeInsets.only(right: 26),
                onPressed: () => _toggleObscure(),
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
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          const SizedBox(
            height: 10,
          ),
          Text.rich(
              TextSpan(text: "Already have an account? ", children: [
                TextSpan(
                    text: "Login",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        //navigate to login page
                        Navigator.pushReplacementNamed(context, '/login');
                      })
              ]),
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 200),
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
