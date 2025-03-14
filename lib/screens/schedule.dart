import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile_plus/timeline_tile_plus.dart';
import 'package:zen/zen_barrel.dart';

class SchedPage extends ConsumerWidget {
  const SchedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final schedule = ref.watch(
      scheduleProvider(tasks.value ?? []),
    );
    return Scaffold(
      body: schedule.when(
        data: (scheduleItems) {
          return _scheduleListView(scheduleItems);
        },
        error: (error, stackTrace) => _scheduleFailListView(context),
        loading: () => Center(
          child: showRunningIndicator(context, "Generating Schedule..."),
        ),
      ),
      floatingActionButton: fabButton(context, () {
        clearScheduleData(ref, tasks.value ?? []);
      }, "Regenerate Schedule", 26),
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
                '${item.taskName}\n${DateFormat('hh:mm a').format(item.startTime)} - ${DateFormat('hh:mm a').format(item.endTime)}\n${DateFormat('dd/MM/yyyy').format(item.startTime)}\n${item.duration} minutes',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _scheduleFailListView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: pagePaddingWithScore,
      children: [
        ScoreCard(),
        Text(
          "Schedule",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 75),
        Text(
            "Oops! I couldn't generate a schedule for you.\nTry again later. 😵",
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        Text("Psst! Checking your \ninternet connection may help... 🙂",
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
