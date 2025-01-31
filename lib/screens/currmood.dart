import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:zen/services/mood_serv.dart';
import 'package:zen/theme/light.dart';
import 'package:zen/theme/consts/moodlist.dart';

class CurrentMood extends StatefulWidget {
  const CurrentMood({super.key});

  @override
  State<CurrentMood> createState() => _CurrentMoodState();
}

class _CurrentMoodState extends State<CurrentMood> {
  String? mood = ""; //String to store the mood for the day

  @override
  void initState() {
    super.initState();
    _loadMood();
  }

  Future<void> _loadMood() async {
    mood = await getMoodFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _moodDisplay(),
    );
  }

  Widget _moodDisplay() {
    return Container(
      decoration: gradientDeco(),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 50, 26, 0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Text(
                  "Mood",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.white),
                ),
              ),
              currMoodCard()
            ],
          ),
        ),
      ),
    );
  }

  Widget currMoodCard() {
    return Stack(
      children: [
        GlassContainer(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            borderRadius: const BorderRadius.all(Radius.circular(36)),
            blur: 75,
            border: 1,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current mood...",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Lottie.asset(reversedMoodList[mood!]!,
                            height: 70, width: 70),
                        const SizedBox(width: 24),
                        Text(mood!,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
