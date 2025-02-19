import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/services/chat_serv.dart';
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
      padding: pagePadding,
      children: [
        Text("Mood", style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 60),
        currMoodCard(context, mood),
        const SizedBox(height: 50),
        fabButton(() {
          Navigator.pushNamed(context, '/mood2');
        }, 'Update Mood', 0),
        const SizedBox(height: 20),
        if (moodExists) motivationContainer(context, mood, ref),
      ],
    );
  }

  Widget currMoodCard(BuildContext context, String mood) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child:
                Lottie.asset(reversedMoodList[mood]!, height: 200, width: 200)),
        const SizedBox(height: 40),
        Center(
          child: Text(
              mood == "Empty"
                  ? "You haven't added\na mood yet.\nAdd one now?"
                  : mood,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center),
        )
      ],
    );
  }

  Widget motivationContainer(BuildContext context, String mood, WidgetRef ref) {
    final motivation = ref.watch(motivationalMessageProvider(mood));

    return motivation.when(
      data: (motivationData) => motivationCard(context, motivationData, ref),
      error: (error, stackTrace) => Center(
          child: Text(
              'Error: $error')), //TODO - Build an AI not available at the moment error card
      loading: () => const Center(
          child: Padding(
        padding: EdgeInsets.fromLTRB(0, 75, 0, 0),
        child: CircularProgressIndicator(),
      )),
    );
  }

  Widget motivationCard(
      BuildContext context, String motivation, WidgetRef ref) {
    final message = motivation
        .replaceAll(
            RegExp(r'AIChatMessage{|content: |\n,|toolCalls: \[\],\n}'), '')
        .trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Text("From Unni...", style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        MarkdownBody(
          data: message,
          styleSheet: markdownStyleSheet,
        ),
        const SizedBox(height: 30),
        fabButton(() {
          ref.read(msgProvider.notifier).clearMessages();
          ref
              .read(msgProvider.notifier)
              .addMessage(Message(text: message, isUser: false));
          Navigator.pushNamed(context, '/chat');
        }, 'Continue to chat with Unni', 0),
        const SizedBox(height: 50),
      ],
    );
  }
}
