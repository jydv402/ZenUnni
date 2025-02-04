import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:zen/services/mood_serv.dart';
import 'package:zen/theme/light.dart';

class MoodPage extends StatelessWidget {
  MoodPage({super.key});

  //get the current users username for referencing that doc

  //ToDo :pass the actual username as docId
  final DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc('username');

  static const moodList = {
    "assets/emoji/chill.json": "Relaxed",
    "assets/emoji/happy.json": "Happy",
    "assets/emoji/halo.json": "Under Control",
    "assets/emoji/nerdy.json": "Study Mode",
    "assets/emoji/neutral.json": "Neutral",
    "assets/emoji/sad.json": "Sad",
    "assets/emoji/angry.json": "Angry",
    "assets/emoji/anxious.json": "Anxious",
    "assets/emoji/overwhelmed.json": "Overwhelmed",
    "assets/emoji/tired.json": "Tired",
    "assets/emoji/sick.json": "Sick",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _moodSelectionScreen(context),
    );
  }

  Widget _moodSelectionScreen(context) {
    return Container(
        decoration: gradientDeco(), //Gradient background
        padding: const EdgeInsets.fromLTRB(26, 50, 26, 0),
        child: SizedBox(
            // SizedBox to fill the entire screen
            width: double.infinity,
            height: double.infinity,
            child: ListView.builder(
              itemCount: moodList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Title
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text("How are you\nfeeling today?",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: Colors.white)),
                  );
                } else {
                  // Mood Cards
                  return _moodCard(context, moodList.keys.elementAt(index - 1),
                      moodList.values.elementAt(index - 1));
                }
              },
            )));
  }

  Widget _moodCard(context, String emoji, String mood) {
    return GestureDetector(
      onTap: () async {
        addMoodToFirestore(mood, userRef);
        await Future.delayed(const Duration(seconds: 2));
      },
      child: GlassContainer(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          borderRadius: const BorderRadius.all(Radius.circular(36)),
          blur: 75,
          border: 1,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Lottie.asset(emoji, height: 70, width: 70),
                const SizedBox(width: 35),
                Text(mood,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white)),
              ],
            ),
          )),
    );
  }
}
