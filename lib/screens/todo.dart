import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/components/scorecard.dart';
import 'package:zen/models/todo_model.dart';
import 'package:zen/services/todo_serv.dart';
import 'package:zen/theme/light.dart';
import 'package:zen/screens/add_todo.dart'; // Import the new page

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ListView(
        padding: pagePaddingWithScore,
        children: [
          ScoreCard(),
          Text(
            'ToDo',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final tasksAsync = ref.watch(taskProvider);

                return tasksAsync.when(
                  data: (tasks) {
                    return _taskListView(tasks, ref); // Pass ref to ListView
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
      floatingActionButton: fabButton(context, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTaskPage()),
        );
      }, "Add New Tasks", 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _taskListView(List<TodoModel> tasks, WidgetRef ref) {
    // Receive ref
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          elevation: 4,
          child: ListTile(
            leading: Checkbox(
              value: task.isDone,
              onChanged: (bool? value) {
                final updatedTask = TodoModel(
                  name: task.name,
                  description: task.description,
                  date: task.date,
                  priority: task.priority,
                  isDone: value ?? false,
                );
                ref.read(taskUpdateProvider(updatedTask)); // Use ref here
              },
            ),
            title: Text(
              task.name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(task.description,
                style: const TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }
}
