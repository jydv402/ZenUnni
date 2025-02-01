import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zen/auth_pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zen/screens/currMood.dart';
import 'package:zen/screens/home.dart';
import 'package:zen/screens/mood.dart';
import 'package:zen/screens/todo.dart';
import 'package:zen/theme/light.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //to ensure firebase plugins are correctly intialised before using it
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); //load the .env file
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); //initialize firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      initialRoute: '/', //Specifies the initial page route
      routes: {
        '/': (context) => const AuthPage(),
        '/home': (context) => const LandPage(),
        '/mood1': (context) => const CurrentMood(),
        '/mood2': (context) => const MoodPage(),
        '/todo': (context) => const Todo(),
      },
    );
  }
}
