import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/components/fab_button.dart';
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
      body: schedule.when(
        data: (scheduleItems) {
          // Use the scheduleItems list to build your UI
          return ListView.builder(
            padding: pagePadding,
            itemCount: scheduleItems.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Text('Schedule',
                    style: Theme.of(context).textTheme.headlineLarge);
              } else {
                final item = scheduleItems[index - 1];
                return ListTile(
                  title: Text(item.taskName,
                      style: Theme.of(context).textTheme.bodySmall),
                  subtitle: Text(
                      '${item.priority}\n${item.startTime} - ${item.endTime}',
                      style: Theme.of(context).textTheme.bodySmall),
                );
              }
            },
          );
        },
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => const CircularProgressIndicator(),
      ),
      floatingActionButton: fabButton(context, () {
        clearScheduleData(ref, tasks.value ?? []);
      }, "Regenerate Schedule", 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
