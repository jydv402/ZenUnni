import 'package:flutter/material.dart';
import 'package:zen/auth_pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zen/screens/home.dart';
import 'package:zen/screens/mood.dart';
import 'package:zen/screens/todo.dart';
import 'firebase_options.dart';

void main() async {
  //to ensure firebase plugins are correctly intialised before using it
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        '/home': (context) => const LandPage(),
        '/mood': (context) => const MoodPage(),
        '/todo': (context) => const TodoPage(),
      },
    );
  }
}
