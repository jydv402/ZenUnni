import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:zen/zen_barrel.dart';

Future<void> main() async {
  //to ensure firebase plugins are correctly intialised before using it
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); //load the .env file
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); //initialize firebase
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/username': (context) => const UsernamePage(),
        '/home': (context) => const LandPage(),
        '/chat': (context) => const ChatPage(),
        '/mood1': (context) => const CurrentMood(),
        '/mood2': (context) => const MoodPage(),
        '/pomo': (context) => const PomodoroPage(),
        '/counter': (context) => const CountdownScreen(),
        '/habit': (context) => const HabitPage(),
        '/profile': (context) => const ProfilePage(),
        '/schedule': (context) => const SchedPage(),
        '/search': (context) => const ConnectPage(),
        '/pass_reset': (context) => const PassResetPage(),
        '/email_verif': (context) => const EmailVerifPage(),
        '/todo': (context) => const TodoListPage(),
        '/add_todo': (context) => const AddTaskPage(),
      },
    );
  }
}
