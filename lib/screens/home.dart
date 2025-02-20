import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:zen/services/mood_serv.dart';
import 'package:zen/services/user_serv.dart';

class LandPage extends ConsumerWidget {
  const LandPage({super.key});

  void logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      // Navigate to the root page after logging out
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNameProvider);
    final mood = ref.watch(moodProvider);

    return Scaffold(
      body: user.when(
        data: (data) {
          return homeScreen(context, user.value, mood.value);
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/profile');
        },
        child: Icon(LineIcons.user),
      ),
    );
  }

  Widget homeScreen(BuildContext context, String? user, mood) {
    final now = DateTime.now().hour;
    final greeting = now < 12
        ? 'Morning'
        : now < 17
            ? 'Afternoon'
            : 'Evening';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: _showGreeting(context, greeting, user),
          ),
          if (mood == null)
            _msgContainer(
                context, "You havent added a mood yet, add it now? 👀"),
          const SizedBox(height: 8),
          _bentoBoxes(context),
        ],
      ),
    );
  }

  Text _showGreeting(BuildContext context, String greeting, user) {
    return Text("Good $greeting, \n$user",
        style: Theme.of(context).textTheme.headlineLarge);
  }

  Container _msgContainer(BuildContext context, String msg) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26), color: Colors.white30),
      child: Text(msg, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  Column _bentoBoxes(BuildContext context) {
    //Centralized variables for easy fiddling
    //defines height of the box
    const double bentoHeight = 150;
    //defines width of the box. Defaults to max occupyable space
    final double bentoWidth = MediaQuery.of(context).size.width;

    //Size of the Icon within the _bento
    const double iconSize = 135;
    //Position of the Icon within the _bento
    const double iconPos = 35;

    return Column(
      spacing: 8,
      children: [
        Row(
          spacing: 8,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _bentoBox(
                context,
                '/chat',
                Color(0xFF7F5EDF),
                bentoHeight * 2 + 8,
                bentoWidth,
                "Talk to\nUnni",
                LineIcons.sms,
                iconSize + 45,
                iconPos + 5,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                spacing: 8,
                children: [
                  _bentoBox(
                    context,
                    '/mood1',
                    Color(0xFF339DF0),
                    bentoHeight,
                    bentoWidth,
                    "Mood",
                    LineIcons.beamingFaceWithSmilingEyes,
                    iconSize,
                    iconPos,
                  ),
                  _bentoBox(
                    context,
                    '/todo',
                    Color(0xFF2BBC87),
                    bentoHeight,
                    bentoWidth,
                    "Todo",
                    LineIcons.checkCircle,
                    iconSize,
                    iconPos,
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          spacing: 8,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _bentoBox(
                  context,
                  '/pomo',
                  Colors.teal,
                  bentoHeight,
                  bentoWidth,
                  "Pomodoro",
                  LineIcons.clock,
                  iconSize + 10,
                  iconPos),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _bentoBox(
                  context,
                  '/schedule',
                  Colors.red,
                  bentoHeight,
                  bentoWidth,
                  "Schedule",
                  LineIcons.calendar,
                  iconSize + 10,
                  iconPos),
            ),
          ],
        )
      ],
    );
  }

  GestureDetector _bentoBox(
      BuildContext context,
      String route,
      Color color,
      double height,
      double width,
      String label,
      IconData icon,
      double iconSize,
      double iconPos) {
    const double pos = 16;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: .2),
                spreadRadius: 5,
                blurRadius: 7,
              )
            ]),
        height: height,
        width: width,
        child: Stack(
          children: [
            Positioned(
              bottom: pos,
              left: pos,
              child: Text(
                label,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Positioned(
                top: -iconPos,
                left: -iconPos,
                child: Icon(
                  icon,
                  color: Colors.black26,
                  size: iconSize,
                )),
            Positioned(
                top: pos,
                right: pos,
                child: Icon(
                  Icons.arrow_outward_rounded,
                  color: Colors.black,
                  size: 32,
                ))
          ],
        ),
      ),
    );
  }
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
