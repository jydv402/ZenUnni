import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:zen/zen_barrel.dart';

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
            ? _moodPage(context, ref, "Empty", "Add mood", false)
            : _moodPage(context, ref, moodData, "Update mood", true),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => Center(
          child: showRunningIndicator(context, "Loading Mood data..."),
        ),
      ),
    );
  }

  Widget _moodPage(BuildContext context, WidgetRef ref, String mood,
      String label, bool moodExists) {
    return ListView(
      padding: pagePaddingWithScore,
      children: [
        const ScoreCard(),
        Text(
          "Mood",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 60),
        _currMoodCard(context, mood),
        const SizedBox(height: 50),
        fabButton(context, () {
          updatePgIndex(ref, 5, 3);
          ref.read(navStackProvider.notifier).push(5);
        }, 'Update Mood', 0),
        const SizedBox(height: 20),
        if (moodExists) _motivationContainer(context, mood, ref),
      ],
    );
  }

  Widget _currMoodCard(BuildContext context, String mood) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Lottie.asset(reversedMoodList[mood]!, height: 200, width: 200),
        ),
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

  Widget _motivationContainer(
      BuildContext context, String mood, WidgetRef ref) {
    final motivation = ref.watch(
      motivationalMessageProvider(mood),
    );

    return motivation.when(
      data: (motivationData) => _motivationCard(context, motivationData, ref),
      error: (error, stackTrace) => _unniFail(context),
      loading: () => Padding(
        padding: const EdgeInsets.only(top: 50),
        child: showRunningIndicator(context, "Unni is thinking..."),
      ),
    );
  }

  Widget _motivationCard(
      BuildContext context, String motivation, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
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
          styleSheet: MarkdownStyleSheet(
            h1: TextStyle(
              // Heading 1
              fontFamily: 'Pop',
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: colors.mdText,
            ),
            h2: TextStyle(
              fontFamily: 'Pop',
              // Heading 2
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: colors.mdText,
            ),
            h3: TextStyle(
              fontFamily: 'Pop',
              // Heading 3
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: colors.mdText,
            ),
            p: TextStyle(
              fontFamily: 'Pop',
              // Paragraph
              fontSize: 14.0,
              color: colors.mdText,
            ),
            strong: TextStyle(
              // Bold text
              fontFamily: 'Pop',
              fontWeight: FontWeight.bold,
              color: colors.mdText,
            ),
            em: TextStyle(
              // Italic text
              fontFamily: 'Pop',
              fontStyle: FontStyle.italic,
              color: colors.mdText,
            ),
            a: const TextStyle(
              // Link
              fontFamily: 'Pop',
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            //TODO: Add roboto local font
            code: GoogleFonts.robotoMono(
              // Code block
              backgroundColor: Colors.white,
              color: colors.mdText,
            ),
            blockquote: const TextStyle(
              // Blockquote
              fontFamily: 'Pop',
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            listBullet: TextStyle(
              // Unordered list
              fontFamily: 'Pop',
              color: colors.mdText,
            ),
            blockSpacing: 24.0, // Spacing between blocks
          ),
        ),
        const SizedBox(height: 30),
        fabButton(context, () {
          ref.read(msgProvider.notifier).clearMessages();
          ref.read(msgProvider.notifier).addMessage(
                Message(text: message, isUser: false),
              );
          Navigator.pushNamed(context, '/chat');
        }, 'Continue to chat with Unni', 0),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _unniFail(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Text("From Unni...", style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        // MarkdownBody(
        //   data:
        //       "Oops! I couldn't munch up a motivational message for you. Try again later.🙂",
        //   styleSheet: markdownStyleSheetWhite,
        // ),
        Text(
            "Oops! I couldn't munch up a motivational message for you.\nTry again later. 😵",
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 10),
        Text("Psst! Checking your \ninternet connection may help...🙂",
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
