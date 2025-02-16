import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/services/user_serv.dart';

class LandPage extends StatelessWidget {
  const LandPage({super.key});

  // Function to log out the user
  void logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      // Navigate to the root page after logging out
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Logout button in the app bar
          IconButton(
              onPressed: () => logoutUser(context),
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: const Center(
          child: Text(
        "WELCOME TO ZENUNNI",
        style:
            TextStyle(fontSize: 24, color: Color.fromARGB(255, 28, 224, 246)),
      )),
      floatingActionButton: Stack(
        children: [
          // Floating Action Button for MoodPage
          pageButtons(context, 'mood', '/mood1',
              Icon(Icons.emoji_emotions_rounded), 10, 10),
          // Floating Action Button for TodoPage
          pageButtons(
              context, 'todo', '/todo', Icon(Icons.edit_rounded), 10, 90),
          //FAB for chat page
          pageButtons(context, 'chat', '/chat',
              Icon(Icons.content_paste_go_rounded), 90, 90),
          //Pomodoro Button
          pageButtons(
              context, 'pomo', '/pomo', Icon(Icons.timer_rounded), 90, 10),
          pageButtons(
              context, 'home', '/home1', Icon(Icons.home_rounded), 10, 170),
        ],
      ),
    );
  }

  Widget pageButtons(BuildContext context, String heroTag, String route,
      Icon icon, double bottom, double right) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: icon,
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(userNameProvider); //USE: ${user.value} to obtain the value

    return Scaffold(
        body: user.when(
      data: (data) {
        return homeScreen(context, user.value);
      },
      error: (error, stackTrace) {
        return Center(child: Text('Error: $error'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    ));
  }

  Widget homeScreen(BuildContext context, String? user) {
    final now = DateTime.now().hour;
    final greeting = now < 12
        ? 'Good Morning'
        : now < 17
            ? 'Good Afternoon'
            : 'Good Evening';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
      child: ListView(
        children: [
          _showGreeting(context, greeting, user),
          const SizedBox(height: 24),
          _bentoBoxes(context),
        ],
      ),
    );
  }

  Text _showGreeting(BuildContext context, String greeting, user) {
    return Text("$greeting, \n$user",
        style: Theme.of(context).textTheme.headlineLarge);
  }

  Row _bentoBoxes(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: _bentoBox(Colors.red, width / 1.5, width / 1.5)),
        const SizedBox(width: 16),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Column(
            children: [
              _bentoBox(Colors.green, width / 2, width / 3.2),
              const SizedBox(height: 16),
              _bentoBox(Colors.blue, width / 2, width / 3.2),
            ],
          ),
        )
      ],
    );
  }

  Container _bentoBox(Color color, double width, double height) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: color,
      ),
      width: width,
      height: height,
    );
  }
}
