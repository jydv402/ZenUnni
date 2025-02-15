import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zen/components/nav.dart';
import 'package:zen/screens/home.dart';
import 'package:zen/auth_pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              //if user is logged in
              if (snapshot.hasData) {
                return const ZenBar();
              }
              //if user is not logged in
              else {
                return const LoginPage();
              }
            }));
  }
}
