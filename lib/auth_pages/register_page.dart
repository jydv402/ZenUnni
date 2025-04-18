import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:zen/zen_barrel.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends ConsumerState<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void registerUser(BuildContext context) async {
    //show loading circle
    showLoadingDialog(context, "Creating your account...");
    //if passwords dont match
    if (_passwordController.text != _confirmPasswordController.text) {
      //pop loading circle
      Navigator.pop(context);
      //display error message
      // displayMessageToUser("Passwords don't match!", context);
      showConfirmDialog(
          context, "Error", "Passwords don't match!", "Retry", Colors.red, () {
        Navigator.pop(context);
      });
    } else {
      //if passwords do match
      //try creating the user
      try {
        //create the user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        try {
          await FirebaseAuth.instance.currentUser?.sendEmailVerification();
        } catch (e) {
          if (context.mounted) {
            // displayMessageToUser(e.toString(), context);
            showConfirmDialog(context, "Error",
                e.toString().replaceAll("-", " "), "Retry", Colors.red, () {
              Navigator.pop(context);
            });
          }
        }

        if (context.mounted) {
          //pop loading circle
          Navigator.pop(context);
          Navigator.pushReplacementNamed(
            context,
            '/email_verif',
          );
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
          // displayMessageToUser(e.code, context);
          showConfirmDialog(context, "Error", e.code.replaceAll("-", " "),
              "Retry", Colors.red, () {
            Navigator.pop(context);
            _emailController.clear();
            _passwordController.clear();
            _confirmPasswordController.clear();
          });
        }
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
    final colors = ref.watch(appColorsProvider);
    final theme = ref.watch(themeProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        padding: pagePadding,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Register",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              toggleThemeButton(
                () => ref.read(themeProvider.notifier).toggleTheme(),
                theme == ThemeMode.light,
                colors.iconClr,
              ),
            ],
          ),
          const SizedBox(height: 40),
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
              suffixIcon: togglePassButton(
                () => _toggleObscure(),
                _obsureText,
                colors.iconClr,
              ),
            ),
            obscureText: _obsureText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              suffixIcon: togglePassButton(
                () => _toggleObscure(),
                _obsureText,
                colors.iconClr,
              ),
            ),
            obscureText: _obsureText,
            style: Theme.of(context).textTheme.bodyMedium,
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
