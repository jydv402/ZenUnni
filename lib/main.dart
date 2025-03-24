import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    // Set the system status bar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent status bar
        statusBarIconBrightness: themeMode == ThemeMode.dark
            ? Brightness.light // White icons for dark mode
            : Brightness.dark, // Black icons for light mode
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      initialRoute: '/', //Specifies the initial page route
      routes: {
        '/': (context) => const AuthPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/username': (context) => const UsernamePage(),
        '/nav': (context) => Navbar(),
        '/home': (context) => const LandPage(),
        '/chat': (context) => ChatPage(),
        '/mood1': (context) => const CurrentMood(),
        '/mood2': (context) => const MoodPage(),
        '/pomo': (context) => const PomodoroPage(),
        '/counter': (context) => const CountdownScreen(),
        '/habit': (context) => const HabitPage(),
        '/profile': (context) => const ProfilePage(),
        '/leader': (context) => const ConnectPage(),
        '/pass_reset': (context) => const PassResetPage(),
        '/email_verif': (context) => const EmailVerifPage(),
        '/add_todo': (context) => const AddTaskPage(),
        '/man_sched': (context) => const ManualSchedEdit(),
      },
    );
  }
}
