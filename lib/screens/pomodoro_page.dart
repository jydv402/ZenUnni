//import 'package:google_fonts/google_fonts.dart';
import 'package:zen/zen_barrel.dart';
import 'package:audioplayers/audioplayers.dart';

void playPomodoroEndSound() async {
  final player = AudioPlayer();
  await player.play(AssetSource('sounds/timer.mp3'));
}

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomo = ref.watch(pomoProvider);
    final pomoNotifier = ref.read(pomoProvider.notifier);
    const space8 = SizedBox(height: 8);
    const space32 = SizedBox(height: 32);
    const space50 = SizedBox(height: 50);

    TextEditingController duration = TextEditingController();
    TextEditingController breakDuration = TextEditingController();
    TextEditingController rounds = TextEditingController();

    duration.text = pomo.duration.toString();
    breakDuration.text = pomo.breakDuration.toString();
    rounds.text = pomo.rounds.toString();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        padding: pagePaddingWithScore,
        children: [
          const ScoreCard(),
          Text(
            'Pomodoro Timer',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          space50,
          _text(context, "Focus duration : "),
          space8,
          _pomoField(context, duration),
          space32,
          _text(context, "Break duration : "),
          space8,
          _pomoField(context, breakDuration),
          space32,
          _text(context, "Number of rounds : "),
          space8,
          _pomoField(context, rounds),
          // space50,
          // fabButton(() {
          //   if (duration.text.isNotEmpty &&
          //       breakDuration.text.isNotEmpty &&
          //       rounds.text.isNotEmpty) {
          //     pomoNotifier.setTimer(int.parse(duration.text),
          //         int.parse(breakDuration.text), int.parse(rounds.text),);
          //     pomoNotifier.startTimer();
          //     Navigator.pushNamed(context, '/counter');
          //   }
          // }, 'Reset', 0),
          // space16,
          // fabButton(() {
          //   if (duration.text.isNotEmpty &&
          //       breakDuration.text.isNotEmpty &&
          //       rounds.text.isNotEmpty) {
          //     pomoNotifier.setTimer(int.parse(duration.text),
          //         int.parse(breakDuration.text), int.parse(rounds.text),);
          //     pomoNotifier.startTimer();
          //     Navigator.pushNamed(context, '/counter');
          //   }
          // }, 'Start Timer', 0),
          space50,
          // Row(
          //   spacing: 8,
          //   children: [
          //     Flexible(
          //       flex: 1,
          //       child: SizedBox(
          //         width: double.infinity,
          //         child: ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //               backgroundColor: Colors.red[400]),
          //           onPressed: () {
          //             pomoNotifier.resetTimer();
          //           },
          //           child: Text('Reset'),
          //         ),
          //       ),
          //     ),
          //     Flexible(
          //       flex: 1,
          //       child: SizedBox(
          //         width: double.infinity,
          //         child: ElevatedButton(
          //           onPressed: () {
          //             if (duration.text.isNotEmpty &&
          //                 breakDuration.text.isNotEmpty &&
          //                 rounds.text.isNotEmpty) {
          //               pomoNotifier.setTimer(
          //                   int.parse(duration.text),
          //                   int.parse(breakDuration.text),
          //                   int.parse(rounds.text),);
          //               pomoNotifier.startTimer();
          //               Navigator.pushNamed(context, '/counter');
          //             }
          //           },
          //           child: Text('Start Timer'),
          //         ),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
      floatingActionButton: fabButton(context, () {
        if (duration.text.isNotEmpty &&
            breakDuration.text.isNotEmpty &&
            rounds.text.isNotEmpty) {
          pomoNotifier.setTimer(
            int.parse(duration.text),
            int.parse(breakDuration.text),
            int.parse(rounds.text),
          );
          pomoNotifier.startTimer();
          Navigator.pushNamed(context, '/counter');
        }
      }, 'Start Timer', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  TextField _pomoField(BuildContext context, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Text _text(context, label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class CountdownScreen extends ConsumerWidget {
  const CountdownScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomo = ref.watch(pomoProvider);

// 🔥 Play sound when timer reaches zero
    if (pomo.timeRemaining == 0) {
      playPomodoroEndSound();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        padding: pagePaddingWithScore,
        children: [
          const ScoreCard(),
          Text(
            pomo.isRunning
                ? pomo.isBreak
                    ? 'Break Session ${pomo.rounds - pomo.currentRound + 1}'
                    : 'Focus Session ${pomo.rounds - pomo.currentRound + 1}'
                : 'Session Ended',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 56),
          _showTime(context, pomo.timeRemaining ~/ 60), //Pass minutes
          _showTime(context, pomo.timeRemaining % 60), //Pass seconds
          const SizedBox(height: 100),
        ],
      ),
      floatingActionButton: fabButton(context, () {
        ref.read(pomoProvider.notifier).stopTimer();
        Navigator.pop(context);
      }, 'Stop Timer', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Text _showTime(BuildContext context, int seconds) {
    return Text(
      seconds.toString().padLeft(2, '0'), // Display time remaining
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: MediaQuery.of(context).size.width * 0.70, height: 0.8),
      textAlign: TextAlign.center,
    );
  }
}
