import 'package:flutter/material.dart';
import 'package:zen/services/task_serv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/models/todo_model.dart';

class Todo extends ConsumerStatefulWidget {
  const Todo({super.key});

  @override
  ConsumerState<Todo> createState() => _TodoState();
}

 //Todo: change variable name for consistency
 //todo: remove print statements 

class _TodoState extends ConsumerState<Todo> {
  //controllers to pick up the info to be stored
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  //variables to store data
  DateTime? _date; //save date
  TimeOfDay? _time; //save time
  String _prior = ""; //save current prior
  List<TaskModel> tasks = []; //to store the tasks in a list
  bool isDone = false;

  DateTime? localDate;
  TimeOfDay? localTime;
  String localPrior = ""; //to display current prior on dialog

  void onChanged(bool? value) {
    setState(() {
      isDone = value ?? false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }


   void _resetDialogFields() {
    _date = null;
    _time = null;
    _prior = "";
    nameController.text = "";
    descController.text = "";
  }

  bool _validateTaskFields() {
    return nameController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        _date != null &&
        _time != null &&
        _prior.isNotEmpty;
  }
  

  void _showTask(BuildContext context, Function(TaskModel) addTaskCallback) {
    nameController.clear();
    descController.clear();

  // Reset the local variables before opening the dialog
     setState(() {
    localDate = null;
    localTime = null;
    localPrior = "";
  });

    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return _newTaskDialog(addTaskCallback);
          },
        );
      },
    );
  }

  Widget _newTaskDialog(Function(TaskModel) addTaskCallback) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(30),
      title: const Text(
        "Add a new task",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        _dialogTextFields(),
        const SizedBox(height: 25),
        _dialogDatePicker(),
        const SizedBox(height: 15),
        _selectedDateText(),
        const SizedBox(height: 15),
        _dialogTimePicker(),
        const SizedBox(height: 20),
        _selectedTimeText(),
        const SizedBox(height: 20),
        _dialogPrioritySelect(),
        const SizedBox(height: 90),
        _dialogButtons(addTaskCallback),
      ],
    );
  }

  Widget _dialogTextFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            label: Text(
              "Task name",
              style: TextStyle(fontSize: 20),
            ),
            hintText: "Enter a name for your task",
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: descController,
          decoration: const InputDecoration(
            label: Text(
              "Task description",
              style: TextStyle(fontSize: 20),
            ),
            hintText: "Enter a description for your task",
          ),
        ),
      ],
    );
  }

  Widget _dialogDatePicker() {
    return ElevatedButton(
        onPressed: () async {
          DateTime? pickDate = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100));
          if (pickDate != null) {
            setState(() {
              localDate = pickDate; //saves to local variable
              _date = pickDate; //to save it to global variable
              print("Selected date: $localDate");
            });
          }
        },
        child: const Text("Select a date"));
  }

  Widget _dialogTimePicker() {
    return ElevatedButton(
      onPressed: () async {
        TimeOfDay? pickTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickTime != null) {
          setState(() {
            localTime = pickTime; // saves to local variable
            _time = pickTime; // saves to global variable
            print("Selected time: $localTime");
          });
        }
      },
      child: const Text("Select a time"),
    );
  }

  Widget _dialogPrioritySelect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Select priority"),
        DropdownButton<String>(
          value: localPrior.isEmpty ? null : localPrior,
          iconSize: 30,
          items: ['High', 'Medium', 'Low']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontSize: 15),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              localPrior = newValue!;
              _prior = newValue;
              print(_prior);
            });
          },
          underline: Container(),
        ),
      ],
    );
  }

  Widget _selectedDateText() {
    return localDate != null
        ? Text(
            "Selected Date: ${localDate!.year}-${localDate!.month.toString().padLeft(2, '0')}-${localDate!.day.toString().padLeft(2, '0')}",
            style: const TextStyle(fontSize: 18),
          )
        : const Text(
            "No date selected currently",
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          );
  }

  Widget _selectedTimeText() {
    return localTime != null
        ? Text(
            "Selected Time: ${localTime!.hour}:${localTime!.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(fontSize: 18),
          )
        : const Text(
            "No time selected currently",
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          );
  }

  Widget _dialogButtons(Function(TaskModel) addTaskCallback) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          onPressed: () {
            _resetDialogFields();
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            size: 25,
            color: Colors.red,
          ),
        ),
        FloatingActionButton(
          onPressed: () {
            if (_validateTaskFields()) {
              DateTime dateTime = DateTime(
                _date!.year,
                _date!.month,
                _date!.day,
                _time!.hour,
                _time!.minute,
              );
              TaskModel task = TaskModel(
                name: nameController.text,
                description: descController.text,
                date: dateTime,
                priority: _prior,
                isDone: isDone,
              );
              addTaskCallback(task);
              ref.read(taskAddProvider(task));
              _resetDialogFields();
              Navigator.pop(context);
            } else {
              print("error fields must be null");
            }
          },
          child: const Icon(Icons.check, size: 25, color: Colors.green),
        ),
      ],
    );
  }

 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(
              'ToDo',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final tasksAsync = ref.watch(
                      taskProvider);

                  return tasksAsync.when(
                    data: (tasks) {
                      return _taskListView(tasks);
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                  );
                },
              ),
            ),
            _addNewTaskButton(),
          ],
        ),
      ),
    );
  }

  Widget _taskListView(List<TaskModel> tasks) {
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
                final updatedTask = TaskModel(
                  name: task.name,
                  description: task.description,
                  date: task.date,
                  priority: task.priority,
                  isDone: value ?? false,
                );
                ref.read(taskUpdateProvider(updatedTask));
              },
            ),
            title: Text(task.name),
            subtitle: Text(task.description),
          ),
        );
      },
    );
  }

  Widget _addNewTaskButton() {
    return ElevatedButton(
      onPressed: () {
        _showTask(context, (TaskModel task) {
          setState(() {
            tasks.add(task);
          });
        });
      },
      child: Text('Add New Tasks'),
    );
  }
}
