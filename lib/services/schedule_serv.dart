import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/models/todo_model.dart';
import 'package:zen/services/ai_serv.dart';
import 'package:zen/services/chat_serv.dart';
import 'package:zen/services/user_serv.dart';

void schedGen(List<TodoModel> tasks, String username) async {
  final StringBuffer taskBuffer = StringBuffer();

  for (final task in tasks) {
    taskBuffer.writeln('-----------------------------');
    taskBuffer.writeln('Task no. = ${tasks.indexOf(task) + 1}');
    taskBuffer.writeln('Task Name: ${task.name}');
    taskBuffer.writeln('Description: ${task.description}');
    taskBuffer.writeln('Date: ${task.date}');
    taskBuffer.writeln('Priority: ${task.priority}');
    taskBuffer.writeln('Status: ${task.isDone ? "Done" : "Not Done"}');
    taskBuffer.writeln('-----------------------------');
  }
  taskBuffer.writeln(
      'Generate a schedule for the above tasks and format it in JSON format. Include well defined schedule with time intervals for each task. Format the JSON as {1:{taskName: "task1", startTime: "10:00", endTime: "11:00"}, 2:{taskName: "task2", startTime: "11:00", endTime: "12:00"},...}. Include only the JSON format and no other messages.');

  final message = taskBuffer.toString();
  final aiService = AIService();
  final response = await aiService.chat(message, [], username);
  print(response
      .replaceAll(
          RegExp(r'AIChatMessage{|content: |\n,|toolCalls: \[\],\n}'), '')
      .trim());
}

final scheduleProvider = FutureProvider.family<String, List<TodoModel>>(
  (ref, tasks) async {
    final userName = ref.watch(userNameProvider);
    final StringBuffer taskBuffer = StringBuffer();

    for (final task in tasks) {
      taskBuffer.writeln('-----------------------------');
      taskBuffer.writeln('Task no. = ${tasks.indexOf(task) + 1}');
      taskBuffer.writeln('Task Name: ${task.name}');
      taskBuffer.writeln('Description: ${task.description}');
      taskBuffer.writeln('Date: ${task.date}');
      taskBuffer.writeln('Priority: ${task.priority}');
      taskBuffer.writeln('Status: ${task.isDone ? "Done" : "Not Done"}');
      taskBuffer.writeln('-----------------------------');
    }
    taskBuffer.writeln(
        'Generate a schedule for the above tasks and format it in JSON format. Include well defined schedule with time intervals for each task. Format the JSON as {1:{taskName: "task1", startTime: "10:00", endTime: "11:00"}, 2:{taskName: "task2", startTime: "11:00", endTime: "12:00"},...}. Include only the JSON format and no other messages.');
    final message = taskBuffer.toString();

    // final message = '${tasks.map((task) {
    //   """
    //   -----------------------------
    //   Task no. = ${tasks.indexOf(task) + 1}
    //   Task Name: ${task.name}
    //   Description: ${task.description}
    //   End Date: ${task.date}

    //   Priority: ${task.priority}
    //   Status: ${task.isDone ? "Done" : "Not Done"}
    //   --------------------------------
    //   """;
    // }).join()}Generate a schedule for the above tasks and format it in JSON format. Include well defined schedule with time intervals for each task. Format the JSON as {1:{taskName: "task1", startTime: "10:00", endTime: "11:00"}, 2:{taskName: "task2", startTime: "11:00", endTime: "12:00"},...}. Include only the JSON format and no other messages.';

    final aiService = AIService();

    print(message);
    final response = await aiService.chat(message, [], userName.value ?? '');
    print(response
        .replaceAll(
            RegExp(r'AIChatMessage{|content: |\n,|toolCalls: \[\],\n}'), '')
        .trim());

    return response
        .replaceAll(
            RegExp(r'AIChatMessage{|content: |\n,|toolCalls: \[\],\n}'), '')
        .trim();
  },
);
