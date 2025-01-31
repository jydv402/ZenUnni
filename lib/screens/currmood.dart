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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _moodDisplay(),
    );
  }

  Widget _moodDisplay() {
    return FutureBuilder<String?>(
      future: getMoodFromFirestore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching mood data'));
        } else {
          return currentMoodContainer(snapshot.data);
        }
      },
    );
  }

  Widget currentMoodContainer(String? mood) {
    return Container(
      decoration: gradientDeco(),
      padding: const EdgeInsets.fromLTRB(26, 50, 26, 0),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: mood == null
            ? ListView(
                children: [
                  Text("Mood",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.white)),
                  const SizedBox(height: 24),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No mood data available",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/mood2');
                        },
                        child: const Text('Add Mood'),
                      )
                    ],
                  ),
                ],
              )
            : ListView(
                children: [
                  Text("Mood",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.white)),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      currMoodCard(mood),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/mood2');
                        },
                        child: const Text('Change Mood'),
                      )
                    ],
                  ),
                ],
              ),
      ),
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
