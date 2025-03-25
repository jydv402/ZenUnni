import 'dart:convert';
import 'package:zen/zen_barrel.dart';
import 'package:json_store/json_store.dart';
import 'package:logger/logger.dart';

final JsonStore _jsonStore = JsonStore();
//const String _scheduleKey = 'saved_sched';

final scheduleProvider =
    FutureProvider.family<List<ScheduleItem>, List<TodoModel>>(
  (ref, tasks) async {
    final username = ref.watch(userNameProvider);
    final String scheduleKey = 'saved_sched_${username.value}';

    var logger = Logger();
    logger.d(scheduleKey);
    final DateTime now = DateTime.now();
    //Check if schedule exists
    final storedSchedule = await _jsonStore.getItem(scheduleKey);
    if (storedSchedule != null) {
      logger.d("Loading schedule from local storage...");
      return (storedSchedule['schedule'] as List)
          .map((item) => ScheduleItem.fromJson(item))
          .toList();
    }

    //Schedule does not exist. Generate it
    // ignore: prefer_interpolation_to_compose_strings
    final userTasks = tasks
        .where(
          (task) => !task.isDone && task.date.isAfter(now),
        )
        .map((task) => '''
    {
      "task": "${task.name}",
      "task_description": "${task.description}",
      "task_due_date": "${task.date}",
      "priority": "${task.priority}",
    },

  ''')
        .join();
    final aiService = AIService();
    logger.d(userTasks);
    final response = await aiService.schedGenIsolate(userTasks);
    logger.d(response);

    final cleanedResponse = response
        .replaceAll(
            RegExp(
                r'AIChatMessage{|content: ```json|\n,|```|toolCalls: \[\],\n}'),
            '')
        .trim();
    final Map<String, dynamic> schedJSON = jsonDecode(cleanedResponse);

    final List<ScheduleItem> scheduleItems = schedJSON.values
        .map(
          (item) => ScheduleItem.fromJson(item),
        )
        .toList();

    await _jsonStore.setItem(scheduleKey,
        {'schedule': scheduleItems.map((item) => item.toJson()).toList()});

    return scheduleItems;
  },
);

/// Clears the cached schedule data so that the scheduleProvider can be re-run.
void clearScheduleData(WidgetRef ref, List<TodoModel> tasks) async {
  final username = ref.watch(userNameProvider);
  final scheduleKey = 'saved_sched_${username.value}';
  await _jsonStore.deleteItem(scheduleKey);
  ref.invalidate(scheduleProvider(tasks));
}
