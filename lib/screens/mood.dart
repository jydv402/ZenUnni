import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:zen/services/mood_serv.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

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
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: _moodSelectionScreen(context), //Mood Selection Screen
      body: FutureBuilder<String?>(
        future: getMoodFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != null) {
            return _moodScreen(context, snapshot.data!);
          } else {
            return _moodSelectionScreen(context);
          }
        },
      ),
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
              itemCount: MoodPage.moodList.length + 1,
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
                  return _moodCard(
                      context,
                      MoodPage.moodList.keys.elementAt(index - 1),
                      MoodPage.moodList.values.elementAt(index - 1));
                }
              },
            )));
  }

  Widget _moodScreen(context, mood) {
    return Center(
      child: Text(
        "You have already selected the mood -> $mood",
      ),
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
      onTap: () async {
        addMoodToFirestore(mood);
        await Future.delayed(const Duration(seconds: 2));
        setState(() {});
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
                Lottie.asset(emoji, height: 60, width: 60),
                const SizedBox(width: 20),
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
