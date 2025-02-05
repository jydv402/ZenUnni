import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:zen/services/mood_serv.dart';
import 'package:zen/theme/light.dart';
import 'package:zen/consts/moodlist.dart';
import 'package:zen/services/ai.dart';

class CurrentMood extends ConsumerWidget {
  // Changed to ConsumerWidget
  const CurrentMood({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mood = ref.watch(moodProvider); // Watch the provider

    return Scaffold(
      body: mood.when(
        // Handle AsyncValue
        data: (moodData) => currentMoodContainer(context, moodData, ref),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget currentMoodContainer(context, String? mood, WidgetRef ref) {
    return Container(
      decoration: gradientDeco(),
      padding: const EdgeInsets.fromLTRB(26, 50, 26, 0),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: mood == null
            ? _noMoodMessage(context)
            : ListView(
                children: [
                  Text("Mood",
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 24),
                  currMoodCard(context, mood),
                  ElevatedButton(
                    onPressed: () async {
                      // Navigate to update mood screen
                      await Navigator.pushNamed(context, '/mood2');
                    },
                    child: const Text('Update Mood'),
                  ),
                  const SizedBox(height: 30),
                  motivationContainer(context, mood, ref),
                ],
              ),
      ),
    );
  }

  Widget _noMoodMessage(BuildContext context) {
    return ListView(
      children: [
        Text("Mood", style: Theme.of(context).textTheme.headlineLarge),
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
              },
              child: const Text('Add Mood'),
            )
          ],
        ),
      ],
    );
  }

  Widget currMoodCard(BuildContext context, String mood) {
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

  Widget motivationContainer(BuildContext context, String mood, WidgetRef ref) {
    final motivation = ref.watch(motivationalMessageProvider(mood));

    return motivation.when(
      data: (motivationData) => motivationCard(context, motivationData),
      error: (error, stackTrace) => Center(
          child: Text(
              'Error: $error')), //TODO - Build an AI not available at the moment error card
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget motivationCard(BuildContext context, String motivation) {
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
                "Motivation...",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text(
                  motivation
                      .replaceAll(
                          RegExp(
                              r'AIChatMessage{|content: |\n,|toolCalls: \[\],\n}'),
                          '')
                      .trim(),
                  style: Theme.of(context).textTheme.headlineSmall)
            ],
          ),
        ),
      ),
    );
  }
}
