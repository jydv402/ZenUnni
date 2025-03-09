import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline_tile_plus/timeline_tile_plus.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/components/scorecard.dart';
import 'package:zen/models/schedule_model.dart';
import 'package:zen/services/schedule_fire_serv.dart';
import 'package:zen/services/schedule_serv.dart';
import 'package:zen/services/todo_serv.dart';

class SchedPage extends ConsumerWidget {
  const SchedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final schedule = ref.watch(scheduleProvider(tasks.value ?? []));

    void addSchedule(List<ScheduleItem> scheduleItems) {
      // final data = {
      //   'date': DateTime.now().toIso8601String(),
      //   'items': scheduleItems,
      // };
      ref.read(scheduleAddProvider(scheduleItems));
    }

    return Scaffold(
      body: schedule.when(
        data: (scheduleItems) {
          return _scheduleListView(scheduleItems);
        },
        error: (error, stackTrace) => Text('Error: $error',
            style: Theme.of(context).textTheme.bodyMedium),
        loading: () => Center(child: const CircularProgressIndicator()),
      ),
      floatingActionButton: schedule.when(
        data: (scheduleItems) => fabButton(context, () {
          addSchedule(scheduleItems);
          clearScheduleData(ref, tasks.value ?? []);
        }, "Regenerate Schedule", 26),
        error: (error, stackTrace) => null,
        loading: () => null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _scheduleListView(List<ScheduleItem> scheduleItems) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: scheduleItems.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScoreCard(),
                Text(
                  'Schedule',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          );
        } else if (index == scheduleItems.length + 1) {
          return const SizedBox(height: 140);
        } else {
          final item = scheduleItems[index - 1];
          return TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: index == 1,
            isLast: index == scheduleItems.length,
            indicatorStyle: IndicatorStyle(
              width: 20,
              color: Colors.blue,
              padding: const EdgeInsets.all(6),
              iconStyle: IconStyle(
                color: Colors.white,
                iconData: Icons.check,
              ),
            ),
            beforeLineStyle: const LineStyle(
              color: Colors.blue,
              thickness: 3,
            ),
            endChild: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${item.startTime} - ${item.endTime}\n${item.taskName} [${item.priority}]',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }
      },
    );
  }
}
