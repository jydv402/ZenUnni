import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zen/zen_barrel.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  final TodoModel? taskToEdit;
  const AddTaskPage({super.key, this.taskToEdit});

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
  bool isRecurring = false;

  DateTime? localDate;
  TimeOfDay? localTime;
  String localPrior = "";

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      nameController.text = widget.taskToEdit!.name;
      descController.text = widget.taskToEdit!.description;
      _date = widget.taskToEdit!.date;
      localDate = widget.taskToEdit!.date;
      _time = TimeOfDay.fromDateTime(widget.taskToEdit!.date);
      localTime = TimeOfDay.fromDateTime(widget.taskToEdit!.date);
      _prior = widget.taskToEdit!.priority;
      localPrior = widget.taskToEdit!.priority;
      isDone = widget.taskToEdit!.isDone;
      isRecurring = widget.taskToEdit!.isDone;
    }
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
    localPrior = "";
  }

  bool validateTaskFields() {
    // Add null checks for controllers
    return nameController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        _date != null &&
        _time != null &&
        (_prior.isNotEmpty ||
            localPrior.isNotEmpty); // Check both prior variables
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: pagePaddingWithScore,
        children: [
          ScoreCard(),
          Text(widget.taskToEdit != null ? "Edit Task" : "Add Task",
              style: headL),
          const SizedBox(height: 25),
          //Task name text field
          _dialogTextFields(context, nameController, "Task name"),
          const SizedBox(height: 25),
          //Task description text field
          _dialogTextFields(context, descController, "Task description"),
          const SizedBox(height: 30),
          _selectedDateText(),
          const SizedBox(height: 15),
          //Set due date button
          fabButton(context, () async {
            DateTime? pickDate = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    textTheme: TextTheme(
                      headlineLarge: GoogleFonts.poppins(
                          fontSize: 26.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      labelLarge: GoogleFonts.poppins(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                      bodyLarge: GoogleFonts.poppins(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    colorScheme: ColorScheme.dark(
                      primary: Colors.blue.shade200,
                      surface: Colors.black, // Change the header color
                      onPrimary: Colors.white, // Change the header text color
                      onSurface: Colors.white, // Change the day text color
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickDate != null) {
              setState(() {
                localDate = pickDate; //saves to local variable
                _date = pickDate; //to save it to global variable
                print("Selected date: $localDate");
              });
            }
          }, "Set due date", 16),
          const SizedBox(height: 30),
          _selectedTimeText(),
          const SizedBox(height: 15),
          //Set due time button
          fabButton(context, () async {
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
          }, "Set due time", 16),
          const SizedBox(height: 30),
          Text(
            "Select task priority",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _dialogPrioritySelect(setState),
          const SizedBox(height: 30),
          _isRecurringCheckBox(),
          const SizedBox(height: 60),
          fabButton(context, () {
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
                isRecurring: isRecurring,
                expired: true,
              );
              if (widget.taskToEdit != null) {
                // Update existing task
                ref.read(
                  taskUpdateFullProvider(task),
                );
              } else {
                // Add new task
                ref.read(
                  taskAddProvider(task),
                );
              }
              resetDialogFields();
              Navigator.pop(context);
            } else {
              print("error fields must not be empty");
            }
          }, widget.taskToEdit != null ? "Update Task" : "Save Task", 0)
        ],
      ),
    );
  }

  Widget _dialogTextFields(
      BuildContext context, TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }

  Widget _selectedDateText() {
    return localDate != null
        ? Text(
            "Selected Date: ${localDate!.year}-${localDate!.month.toString().padLeft(2, '0')}-${localDate!.day.toString().padLeft(2, '0')}",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          )
        : Text(
            "No date selected currently",
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          );
  }

  Widget _selectedTimeText() {
    return localTime != null
        ? Text(
            "Selected Time: ${localTime!.hour}:${localTime!.minute.toString().padLeft(2, '0')}",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          )
        : Text(
            "No time selected currently",
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          );
  }

//TODO: use a segmented button
  Widget _dialogPrioritySelect(
      void Function(
        void Function(),
      ) setState) {
    return Center(
      child: Wrap(
        spacing: 2,
        children: ['High', 'Medium', 'Low'].map((String value) {
          return ChoiceChip(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
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
                .bodyMedium
                ?.copyWith(color: Colors.black),
          );
        }).toList(),
      ),
    );
  }

  Widget _isRecurringCheckBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Is this a recurring task ?',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Checkbox(
            activeColor: Colors.white,
            focusColor: Colors.white,
            value: isRecurring,
            onChanged: (bool? value) {
              setState(() {
                isRecurring = value ?? false;
              });
            })
      ],
    );
  }
}
