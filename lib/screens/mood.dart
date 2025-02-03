import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:zen/services/mood_serv.dart';
import 'package:zen/theme/consts/moodlist.dart';
import 'package:zen/theme/light.dart';

class MoodPage extends ConsumerWidget {
  const MoodPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
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
                      style: Theme.of(context).textTheme.headlineLarge),
                );
              } else {
                // Mood Cards
                return _moodCard(context, moodList.keys.elementAt(index - 1),
                    moodList.values.elementAt(index - 1), ref);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _moodCard(
      BuildContext context, String emoji, String mood, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await ref.read(moodAddProvider(mood).future);
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(150),
            borderRadius: BorderRadius.circular(36),
          ),
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Lottie.asset(emoji, height: 70, width: 70),
                const SizedBox(width: 24),
                Text(mood, style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          )),
    );
  }
}
