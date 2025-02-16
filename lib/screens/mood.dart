import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/services/mood_serv.dart'; // Import your provider
import 'package:zen/consts/moodlist.dart';
import 'package:zen/theme/light.dart'; // Import your mood list

class MoodPage extends ConsumerStatefulWidget {
  // Use StatefulWidget
  const MoodPage({super.key});

  @override
  ConsumerState<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends ConsumerState<MoodPage> {
  int _currentMoodIndex = 0; // Index of the selected mood

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 56, 0, 20),
              child: Text(
                "How are you\nfeeling today?",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 80),
            // Mood Emoji Display
            Center(
              child: Lottie.asset(
                moodList.keys.elementAt(_currentMoodIndex),
                height: 200, // Adjust size as needed
                width: 200,
              ),
            ),
            const SizedBox(height: 80),
            // Mood Name Display
            Center(
              // Center the mood name
              child: Text(
                moodList.values.elementAt(_currentMoodIndex),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 70),
            SliderTheme(
              data: SliderThemeData(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  trackHeight: 50,
                  showValueIndicator: ShowValueIndicator.always,
                  valueIndicatorColor: Colors.white,
                  valueIndicatorTextStyle:
                      Theme.of(context).textTheme.headlineSmall,
                  activeTickMarkColor: Colors.black,
                  inactiveTickMarkColor: Colors.white,
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.black,
                  thumbColor:
                      _currentMoodIndex == 0 ? Colors.white : Colors.black),
              child: Slider(
                autofocus: true,
                value: _currentMoodIndex.toDouble(),
                min: 0,
                max: moodList.length - 1.toDouble(),
                divisions: moodList.length - 1,
                label: (_currentMoodIndex + 1).toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentMoodIndex = value.toInt();
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: fabButton(() async {
        await ref.read(
            moodAddProvider(moodList.values.elementAt(_currentMoodIndex))
                .future);
        if (context.mounted) {
          Navigator.pop(context);
        }
      }, "Add Mood"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
