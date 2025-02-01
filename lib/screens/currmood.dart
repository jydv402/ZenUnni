import 'package:flutter/material.dart';
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
  Future<String?>? moodFuture;

  @override
  void initState() {
    super.initState();
    _refreshMood();
  }

  void _refreshMood() {
    setState(() {
      moodFuture = getMoodFromFirestore();
    });
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
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 24),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No mood data available",
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/mood2');
                          _refreshMood();
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
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      currMoodCard(mood),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/mood2');
                          _refreshMood();
                        },
                        child: const Text('Update Mood'),
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget currMoodCard(String mood) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(150),
        borderRadius: BorderRadius.circular(36),
      ),
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                    ?.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Lottie.asset(reversedMoodList[mood]!, height: 70, width: 70),
                  const SizedBox(width: 24),
                  Text(mood, style: Theme.of(context).textTheme.headlineMedium)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
