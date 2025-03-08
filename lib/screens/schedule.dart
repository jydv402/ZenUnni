import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/components/scorecard.dart';
import 'package:zen/services/schedule_serv.dart';
import 'package:zen/services/todo_serv.dart';
import 'package:zen/theme/light.dart';

class SchedPage extends ConsumerWidget {
  const SchedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final schedule = ref.watch(scheduleProvider(tasks.value ?? []));
    return Scaffold(
      body: ListView(
        padding: pagePaddingWithScore,
        children: [
          ScoreCard(),
          Text('Schedule', style: Theme.of(context).textTheme.headlineLarge),
          Expanded(
            child: Column(
              children: [
                schedule.when(
                  data: (scheduleItems) {
                    return ListView.builder(
                      shrinkWrap:
                          true, // Added shrinkWrap to prevent ListView.builder from taking infinite space
                      physics:
                          NeverScrollableScrollPhysics(), // Added physics to disable inner scrolling
                      itemCount: scheduleItems.length,
                      itemBuilder: (context, index) {
                        final item = scheduleItems[index];
                        return ListTile(
                          title: Text(item.taskName,
                              style: Theme.of(context).textTheme.bodySmall),
                          subtitle: Text(
                              '${item.priority}\n${item.startTime} - ${item.endTime}',
                              style: Theme.of(context).textTheme.bodySmall),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) => Text('Error: $error',
                      style: Theme.of(context).textTheme.bodySmall),
                  loading: () =>
                      Center(child: const CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: fabButton(context, () {
        clearScheduleData(ref, tasks.value ?? []);
      }, "Regenerate Schedule", 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
