import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/components/fab_button.dart';
import 'package:zen/models/todo_model.dart';
import 'package:zen/services/todo_serv.dart';
import 'package:zen/theme/light.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({super.key});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  String _prior = "";
  bool isDone = false;

  DateTime? localDate;
  TimeOfDay? localTime;
  String localPrior = "";

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

  void resetDialogFields() {
    _date = null;
    _time = null;
    _prior = "";
    nameController.text = "";
    descController.text = "";
  }

  bool validateTaskFields() {
    return nameController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        _date != null &&
        _time != null &&
        _prior.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Add SingleChildScrollView for scrollable content
          child: Column(
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
              const SizedBox(height: 25),
              _dialogPrioritySelect(setState),
              const SizedBox(height: 25),
              _dialogButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // ... (All the _dialogTextFields, _dialogDatePicker, etc. widgets from your original code) ...
  Widget _dialogTextFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
            controller: nameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: 'Task Name',
                hintStyle: TextStyle(color: Colors.white54),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)))),
        const SizedBox(height: 20),
        TextField(
            controller: descController,
            decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.white54),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)))),
      ],
    );
  }

  Widget _dialogDatePicker() {
    return fabButton(context, () async {
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
    }, "Select a date", 0);
  }

  Widget _selectedDateText() {
    return localDate != null
        ? Text(
            "Selected Date: ${localDate!.year}-${localDate!.month.toString().padLeft(2, '0')}-${localDate!.day.toString().padLeft(2, '0')}",
            style: const TextStyle(fontSize: 16),
          )
        : const Text(
            "No date selected currently",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
          );
  }

  Widget _dialogTimePicker() {
    return fabButton(context, () async {
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
    }, "Select a time", 0);
  }

  Widget _selectedTimeText() {
    return localTime != null
        ? Text(
            "Selected Time: ${localTime!.hour}:${localTime!.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(fontSize: 16),
          )
        : const Text(
            "No time selected currently",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
          );
  }

  Widget _dialogPrioritySelect(void Function(void Function()) setState) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Priority",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 2,
          children: ['High', 'Medium', 'Low'].map((String value) {
            return ChoiceChip(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26)),
              label: Text(value),
              selected: localPrior == value,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    localPrior = value;
                    _prior = value;
                  }
                });
              },
              showCheckmark: false,
              selectedColor: Colors.blue.shade200,
              backgroundColor: Colors.grey,
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _dialogButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          onPressed: () {
            resetDialogFields();
            Navigator.pop(context);
          },
          child: const Icon(Icons.close, size: 25, color: Colors.red),
        ),
        FloatingActionButton(
          onPressed: () {
            if (validateTaskFields()) {
              DateTime dateTime = DateTime(
                _date!.year,
                _date!.month,
                _date!.day,
                _time!.hour,
                _time!.minute,
              );
              TodoModel task = TodoModel(
                name: nameController.text,
                description: descController.text,
                date: dateTime,
                priority: _prior,
                isDone: isDone,
              );
              ref.read(taskAddProvider(task));
              resetDialogFields();
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
}
