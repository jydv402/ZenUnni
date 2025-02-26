import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/services/mood_serv.dart';
import 'package:zen/consts/moodlist.dart';
import 'package:zen/theme/light.dart';

class MoodPage extends ConsumerStatefulWidget {
  const MoodPage({super.key});

  @override
  ConsumerState<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends ConsumerState<MoodPage> {
  int _currentMoodIndex = 0; // Index of the selected mood

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: pagePadding,
        children: [
          Text(
            "How are you\nfeeling today?",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 80),
          // Mood Icon
          Center(
            child: Lottie.asset(
              moodList.keys.elementAt(_currentMoodIndex),
              height: 200,
              width: 200,
            ),
          ),
          const SizedBox(height: 40),
          // Mood Name Display
          Center(
            child: Text(
              moodList.values.elementAt(_currentMoodIndex),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text("${_currentMoodIndex + 1}/${moodList.length}",
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
          const SizedBox(height: 80),
          SliderTheme(
            data: SliderThemeData(
                trackHeight: 50,
                // showValueIndicator: ShowValueIndicator.always,
                // valueIndicatorColor: Colors.black,
                // valueIndicatorTextStyle:
                //     Theme.of(context).textTheme.headlineSmall,
                // valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                activeTickMarkColor: Colors.black,
                inactiveTickMarkColor: Colors.white,
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.black,
                thumbColor:
                    _currentMoodIndex == 0 ? Colors.white : Colors.black),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Slider(
                autofocus: true,
                value: _currentMoodIndex.toDouble(),
                min: 0,
                max: moodList.length - 1.toDouble(),
                divisions: moodList.length - 1,
                //label: (_currentMoodIndex + 1).toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentMoodIndex = value.toInt();
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: fabButton(context, () async {
        await ref.read(
            moodAddProvider(moodList.values.elementAt(_currentMoodIndex))
                .future);
        if (context.mounted) {
          Navigator.pop(context);
        }
      }, "Add Mood", 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
