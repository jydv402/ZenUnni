import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/zen_barrel.dart';

import 'package:logger/logger.dart';

final scheduleProvider =
    FutureProvider.family<List<ScheduleItem>, List<TodoModel>>(
  (ref, tasks) async {
    // ignore: prefer_interpolation_to_compose_strings
    final userTasks = tasks.map((task) => '''

  Task no.${tasks.indexOf(task) + 1}
  Task Name: ${task.name}

  Due Date: ${task.date}
  Task Description: ${task.description}
  Status: ${task.isDone ? "Done" : "Not Done"}

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

    final List<ScheduleItem> scheduleItems =
        schedJSON.values.map((item) => ScheduleItem.fromJson(item)).toList();

    return scheduleItems;
  },
);

/// Clears the cached schedule data so that the scheduleProvider can be re-run.
void clearScheduleData(WidgetRef ref, List<TodoModel> tasks) {
  ref.invalidate(scheduleProvider(tasks));
}
