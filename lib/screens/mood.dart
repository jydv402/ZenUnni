import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:zen/services/mood_serv.dart';

class MoodPage extends StatelessWidget {
  const MoodPage({super.key});

  static const moodList = {
    "😄": "Happy",
    "😇": "Under control",
    "😭": "Sad",
    "🤯": "Overwhelmed",
    "🤬": "Angry",
    "😴": "Tired",
    "😐": "Neutral",
    "🤔": "Confused",
    "😷": "Sick",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _moodSelectionScreen(context), //Mood Selection Screen
      // body: DateTime.now().day == DateTime.parse(todaysMood["updatedOn"]!).day
      //     ? _moodScreen(context)
      //     : _moodSelectionScreen(context),
    );
  }

  Widget _moodSelectionScreen(context) {
    return Container(
        decoration: _gradientDeco(), //Gradient background
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
                        style: Theme.of(context).textTheme.headlineLarge),
                  );
                } else {
                  // Mood Cards
                  return _moodCard(context, moodList.keys.elementAt(index - 1),
                      moodList.values.elementAt(index - 1));
                }
              },
            )));
  }

  Widget _moodScreen(context) {
    return const Center(
      child: Text("Mood Screen"),
    );
  }

  BoxDecoration _gradientDeco() {
    return const BoxDecoration(
        gradient: LinearGradient(
            transform: GradientRotation(0.4),
            stops: [0.005, 0.3, 0.9],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(240, 255, 86, 34),
              Color.fromARGB(240, 56, 50, 109),
              Color.fromARGB(240, 155, 39, 176)
            ]));
  }

  Widget _moodCard(context, String emoji, String mood) {
    return GestureDetector(
      onTap: () {
        addMoodToFirestore(mood);
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
                Text(emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 20),
                Text(mood, style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          )),
    );
  }
}
