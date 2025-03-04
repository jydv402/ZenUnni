import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('password reset link sent!\ncheck your email'),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [resetEmailContainer(context), resetEmailButton(context)],
        ),
      )),
    );
  }

  Widget resetEmailContainer(context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //  crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Forgot Your Password?",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
              SizedBox(height:10),
          Text(
            "Enter your email and we'll send you a reset link",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
      
          TextField(
              controller: resetEmailController,
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  hintText: 'enter your email',
                  hintStyle: TextStyle(color: Colors.white54),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)))),
        ],
      ),
    );
  }

  Widget resetEmailButton(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: () {
          passwordReset();
        },
        child: Text(
          'Reset Password',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
