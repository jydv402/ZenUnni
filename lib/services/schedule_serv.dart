import 'dart:convert';
import 'package:zen/zen_barrel.dart';

import 'package:logger/logger.dart';

final scheduleProvider =
    FutureProvider.family<List<ScheduleItem>, List<TodoModel>>(
  (ref, tasks) async {
    // ignore: prefer_interpolation_to_compose_strings
    final userTasks = tasks.map((task) => '''
    {
      "task": "${task.name}",
      "description": "${task.description}",
      "date": "${task.date}",
      "priority": "${task.priority}",
      "isDone": ${task.isDone}
    },

  ''').join();
    final aiService = AIService();

    var logger = Logger();
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

    return scheduleItems;
  },
);

/// Clears the cached schedule data so that the scheduleProvider can be re-run.
void clearScheduleData(WidgetRef ref, List<TodoModel> tasks) {
  ref.invalidate(
    scheduleProvider(tasks),
  );
}
