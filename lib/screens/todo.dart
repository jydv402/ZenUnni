import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:zen/zen_barrel.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskList = ref.watch(taskProvider);
    return Scaffold(
      body: taskList.when(
        data: (tasks) => _taskListView(tasks, ref),
        loading: () => Center(
          child: showRunningIndicator(context, "Loading Todo data..."),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
      floatingActionButton: fabButton(context, () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddTaskPage(),
          ),
        );
      }, "Add New Tasks", 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _taskListView(List<TodoModel> tasks, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      itemCount: tasks.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScoreCard(),
                Text(
                  'Todo',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          );
        } else if (index == tasks.length + 1) {
          return const SizedBox(height: 140);
        } else {
          final task = tasks[index - 1];
          return Container(
            padding: const EdgeInsets.fromLTRB(26, 6, 10, 26),
            margin: const EdgeInsets.fromLTRB(6, 6, 6, 0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    task.expired
                        ? const Spacer()
                        : Text(
                            "Task Expired",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic),
                          ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        showConfirmDialog(
                          context,
                          "Delete Task ?",
                          "Are you sure you want to delete this task ?",
                          "Delete",
                          Colors.red,
                          () {
                            ref.read(
                              taskDeleteProvider(task),
                            );
                            Navigator.pop(context);
                          },
                        );
                      },
                      icon: Icon(
                        LineIcons.alternateTrash,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTaskPage(taskToEdit: task),
                          ),
                        );
                      },
                      icon: Icon(
                        LineIcons.pen,
                        color: Colors.white,
                      ),
                    ),
                    task.expired
                        ? Checkbox(
                            value: task.isDone,
                            side:
                                const BorderSide(color: Colors.white, width: 2),
                            activeColor: Colors.white,
                            overlayColor: WidgetStateProperty.all(Colors.white),
                            focusColor: Colors.white,
                            checkColor: Colors.black,
                            onChanged: (bool? value) {
                              final updatedTask = TodoModel(
                                name: task.name,
                                description: task.description,
                                date: task.date,
                                priority: task.priority,
                                isDone: value ?? false,
                                expired: task.expired,
                              );
                              ref.read(
                                taskUpdateFullProvider(updatedTask),
                              );
                              if (task.priority == "High") {
                                ref.read(
                                  scoreIncrementProvider(
                                      value! ? 25 : -25), //High priority score
                                );
                              } else if (task.priority == "Medium") {
                                ref.read(
                                  scoreIncrementProvider(value!
                                      ? 15
                                      : -15), //Medium priority score
                                );
                              } else {
                                ref.read(
                                  scoreIncrementProvider(
                                      value! ? 10 : -10), //Low priority score
                                );
                              }
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                Text(
                  task.name,
                  style: task.expired
                      ? Theme.of(context).textTheme.headlineMedium
                      : Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white,
                          decorationThickness: 2),
                ),
                const SizedBox(height: 10),
                Text(
                  task.description,
                  style: task.expired
                      ? Theme.of(context).textTheme.headlineSmall
                      : Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.white,
                            decorationThickness: 2,
                          ),
                ),
                const SizedBox(height: 26),
                Text(
                  "•  Due Date: ${DateFormat('dd MMM y').format(task.date)}",
                  style: task.expired
                      ? Theme.of(context).textTheme.bodySmall
                      : Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white,
                          decorationThickness: 2),
                ),
                const SizedBox(height: 10),
                Text(
                  "•  Due Time: ${DateFormat('hh:mm a').format(task.date)}",
                  style: task.expired
                      ? Theme.of(context).textTheme.bodySmall
                      : Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white,
                          decorationThickness: 2),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: "•  Priority: ",
                      style: task.expired
                          ? Theme.of(context).textTheme.bodySmall
                          : Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.white,
                              decorationThickness: 2),
                    ),
                    TextSpan(
                      text: task.priority,
                      style: task.expired
                          ? Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: task.priority == "High"
                                    ? Colors.red.shade200
                                    : task.priority == "Medium"
                                        ? Colors.orange.shade200
                                        : Colors.green.shade200,
                              )
                          : Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: task.priority == "High"
                                    ? Colors.red.shade200
                                    : task.priority == "Medium"
                                        ? Colors.orange.shade200
                                        : Colors.green.shade200,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.white,
                                decorationThickness: 2,
                              ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
