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
  late Future<String?> moodFuture;

  @override
  void initState() {
    super.initState();
    moodFuture = getMoodFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _moodDisplay(),
    );
  }

  Widget _moodDisplay() {
    return FutureBuilder<String?>(
      future: moodFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No mood data available'));
        } else {
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
                    currMoodCard(snapshot.data!)
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget currMoodCard(String mood) {
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Lottie.asset(reversedMoodList[mood]!,
                          height: 70, width: 70),
                      const SizedBox(width: 24),
                      Text(
                        mood,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                            ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
