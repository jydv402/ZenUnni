import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/models/schedule_model.dart';
import 'package:zen/models/todo_model.dart';
import 'package:zen/services/ai_serv.dart';
import 'package:zen/services/chat_serv.dart';
import 'package:zen/services/mood_serv.dart';
import 'package:zen/services/user_serv.dart';

// void schedGen(List<TodoModel> tasks, String username) async {
//   final StringBuffer taskBuffer = StringBuffer();

//   for (final task in tasks) {
//     taskBuffer.writeln('-----------------------------');
//     taskBuffer.writeln('Task no. = ${tasks.indexOf(task) + 1}');
//     taskBuffer.writeln('Task Name: ${task.name}');
//     taskBuffer.writeln('Description: ${task.description}');
//     taskBuffer.writeln('Date: ${task.date}');
//     taskBuffer.writeln('Priority: ${task.priority}');
//     taskBuffer.writeln('Status: ${task.isDone ? "Done" : "Not Done"}');
//     taskBuffer.writeln('-----------------------------');
//   }
//   taskBuffer.writeln(
//       'Generate a schedule for the above tasks and format it in JSON format. Include well defined schedule with time intervals for each task. Format the JSON as {1:{taskName: "task1", startTime: "10:00", endTime: "11:00"}, 2:{taskName: "task2", startTime: "11:00", endTime: "12:00"},...}. Include only the JSON format and no other messages.');

//   final message = taskBuffer.toString();
//   final aiService = AIService();
//   final response = await aiService.chat(message, [], username);
//   print(response
//       .replaceAll(
//           RegExp(
//               r'AIChatMessage{|content: ```json|\n,|```|toolCalls: \[\],\n}'),
//           '')
//       .trim());
// }

final scheduleProvider =
    FutureProvider.family<List<ScheduleItem>, List<TodoModel>>(
  (ref, tasks) async {
    // ignore: prefer_interpolation_to_compose_strings
    final userTasks = tasks.map((task) => '''

  Task no.${tasks.indexOf(task) + 1}
  Task Name: ${task.name}
  Priority: ${task.priority}
  Due Date: ${task.date}
  Task Description: ${task.description}
  Status: ${task.isDone ? "Done" : "Not Done"}

  ''').join();
    final aiService = AIService();

    print(userTasks);
    final response = await aiService.schedGenIsolate(userTasks);
    print(response);

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
