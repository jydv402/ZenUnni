import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/services/schedule_serv.dart';
import 'package:zen/services/todo_serv.dart';
import 'package:zen/theme/light.dart';

class SchedPage extends ConsumerWidget {
  const SchedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final schedule = ref.watch(scheduleProvider(tasks.value ?? []));
    return schedule.when(
      data: (schedule) => Scaffold(
        body: ListView(
          padding: pagePadding,
          children: [
            Text(
              "Schedule",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 60),
            Text(
              schedule,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
