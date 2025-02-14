import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      body: Container(
        decoration: gradientDeco(),
        padding: const EdgeInsets.fromLTRB(26, 50, 26, 0),
        child: ListView(
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
            ElevatedButton(
                onPressed: () {
                  pomoNotifier.startTimer();
                },
                child: Text('Start Timer')),
            ElevatedButton(
                onPressed: () {
                  pomoNotifier.stopTimer();
                },
                child: Text('Stop Timer')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
                          child: Text('Start'),
                        ),
                      )
                    ],
                  )
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add_alarm_rounded),
      ),
    );
  }
}
