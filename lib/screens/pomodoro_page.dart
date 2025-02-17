import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/services/pomodoro_serve.dart';
import 'package:zen/theme/light.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomo = ref.watch(pomoProvider);
    final pomoNotifier = ref.read(pomoProvider.notifier);

    TextEditingController duration = TextEditingController();
    TextEditingController breakDuration = TextEditingController();
    TextEditingController rounds = TextEditingController();

    return Scaffold(
      body: ListView(
        padding: pagePadding,
        children: [
          Text(
            'Pomodoro Timer',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 24),
          Text("Focus session : ${pomo.duration.toString()} minutes",
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          Text(
            "Break : ${pomo.breakDuration.toString()} minutes",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Text(
            "Rounds : ${pomo.rounds.toString()}",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Text(
            "isRunning : ${pomo.isRunning.toString()}",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          fabButton(() {
            duration.clear();
            breakDuration.clear();
            rounds.clear();

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Set Pomodoro Timer'),
                  actions: [
                    TextField(
                        controller: duration,
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: const InputDecoration(
                          labelText: 'Duration (minutes)',
                        )),
                    const SizedBox(height: 10),
                    TextField(
                      controller: breakDuration,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: const InputDecoration(
                        labelText: 'Break Duration (minutes)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: rounds,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: const InputDecoration(
                        labelText: 'Number of Rounds',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              if (duration.text.isNotEmpty &&
                                  breakDuration.text.isNotEmpty &&
                                  rounds.text.isNotEmpty) {
                                pomoNotifier.setTimer(
                                    int.parse(duration.text),
                                    int.parse(breakDuration.text),
                                    int.parse(rounds.text));
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Set Timer'),
                          ),
                        )
                      ],
                    )
                  ],
                );
              },
            );
          }, 'Edit', 26)
        ],
      ),
      floatingActionButton: fabButton(() {
        // pomoNotifier.setTimer(int.parse(duration.text),
        //     int.parse(breakDuration.text), int.parse(rounds.text));
        pomoNotifier.startTimer();
        Navigator.pushNamed(context, '/counter');
      }, 'Start Timer', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CountdownScreen extends ConsumerWidget {
  const CountdownScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomo = ref.watch(pomoProvider);

    return Scaffold(
      body: ListView(
        padding: pagePadding,
        children: [
          Text(
            pomo.isRunning
                ? pomo.isBreak
                    ? 'Break Session'
                    : 'Focus Session'
                : 'Session Ended',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 56),
          _showTime(context, pomo.timeRemaining ~/ 60), //Pass minutes
          _showTime(context, pomo.timeRemaining % 60), //Pass seconds
          const SizedBox(height: 100),
        ],
      ),
      floatingActionButton: fabButton(() {
        ref.read(pomoProvider.notifier).stopTimer();
        Navigator.pop(context);
      }, 'Stop Timer', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Text _showTime(BuildContext context, int seconds) {
    return Text(
      seconds.toString().padLeft(2, '0'), // Display time remaining
      style: Theme.of(context)
          .textTheme
          .headlineLarge
          ?.copyWith(fontSize: MediaQuery.of(context).size.width * 0.5),
      textAlign: TextAlign.center,
    );
  }
}
