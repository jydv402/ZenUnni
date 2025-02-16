import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:zen/services/mood_serv.dart';
import 'package:zen/theme/light.dart';
import 'package:zen/consts/moodlist.dart';

class CurrentMood extends ConsumerWidget {
  // Changed to ConsumerWidget
  const CurrentMood({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mood = ref.watch(moodProvider); // Watch the provider

    return Scaffold(
      body: mood.when(
        // Handle AsyncValue
        data: (moodData) => moodData == null
            ? moodPage(context, ref, "Empty", "Add mood", false)
            : moodPage(context, ref, moodData, "Update mood", true),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget moodPage(BuildContext context, WidgetRef ref, String mood,
      String label, bool moodExists) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 56, 16, 26),
      children: [
        Text("Mood", style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 24),
        currMoodCard(context, mood),
        ElevatedButton(
          onPressed: () async {
            // Navigate to update mood screen
            await Navigator.pushNamed(context, '/mood2');
          },
          child: Text(label),
        ),
        const SizedBox(height: 30),
        if (moodExists) motivationContainer(context, mood, ref),
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
                mood == "Empty" ? "No mood added..." : "Current mood...",
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
                  Text(mood == "Empty" ? "Log mood?" : mood,
                      style: Theme.of(context).textTheme.headlineMedium)
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
              MarkdownBody(
                data: motivation
                    .replaceAll(
                        RegExp(
                            r'AIChatMessage{|content: |\n,|toolCalls: \[\],\n}'),
                        '')
                    .trim(),
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              // Text(
              //     motivation
              //         .replaceAll(
              //             RegExp(
              //                 r'AIChatMessage{|content: |\n,|toolCalls: \[\],\n}'),
              //             '')
              //         .trim(),
              //     style: Theme.of(context).textTheme.headlineSmall)
            ],
          ),
        ),
      ),
    );
  }
}
