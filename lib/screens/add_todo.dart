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
  DateTime? _date; // for non- recurring task date
  TimeOfDay? _time; // for non- recurring task time
  String _prior = "";
  bool isDone = false;
  bool isRecurring = false;
  TimeOfDay? _fromTime; //for recurring tasks from time
  TimeOfDay? _toTime; // for recurring tasks to time
  List<String> selectedWeekdays = [];

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
      _fromTime = widget.taskToEdit!.fromTime.isNotEmpty
          ? TodoModel.stringToTimeOfDay(widget.taskToEdit!.fromTime)
          : null;
      _toTime = widget.taskToEdit!.toTime.isNotEmpty
          ? TodoModel.stringToTimeOfDay(widget.taskToEdit!.toTime)
          : null;
      _prior = widget.taskToEdit!.priority;
      localPrior = widget.taskToEdit!.priority;
      isDone = widget.taskToEdit!.isDone;
      isRecurring = widget.taskToEdit!.isRecurring;
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
    _fromTime = null;
    _toTime = null;
    localPrior = "";
    selectedWeekdays.clear();
  }

  bool validateTaskFields() {
    // Add null checks for controllers
    if (isRecurring) {
      // do date,time,selectedweekdays validation if recurring
      return nameController.text.isNotEmpty &&
          descController.text.isNotEmpty &&
          (_fromTime != null) &&
          (_toTime != null) &&
          selectedWeekdays.isNotEmpty;
    } else {
      // do date, time, and priority for non-recurring tasks
      return nameController.text.isNotEmpty &&
          descController.text.isNotEmpty &&
          (_date != null) &&
          (_time != null) &&
          (_prior.isNotEmpty ||
              localPrior.isNotEmpty); // Check both prior variables
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        padding: pagePaddingWithScore,
        children: [
          const ScoreCard(),
          Text(widget.taskToEdit != null ? "Edit Task" : "Add Task",
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 25),
          //Task name text field
          _dialogTextFields(context, nameController, "Task name"),
          const SizedBox(height: 25),
          //Task description text field
          _dialogTextFields(context, descController, "Task description"),
          const SizedBox(height: 30),
          _isRecurringCheckBox(),
          const SizedBox(height: 30),

          if (!isRecurring) ...[
            _selectedDateText(),
            const SizedBox(height: 15),
            fabButton(context, () async {
              DateTime? pickDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                // builder: (BuildContext context, Widget? child) {
                //   return Theme(
                //     data: Theme.of(context).copyWith(
                //       textTheme: TextTheme(
                //         headlineLarge: GoogleFonts.poppins(
                //             fontSize: 26.0,
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold),
                //         labelLarge: GoogleFonts.poppins(
                //           fontSize: 18.0,
                //           color: Colors.white,
                //         ),
                //         bodyLarge: GoogleFonts.poppins(
                //           fontSize: 16.0,
                //           color: Colors.white,
                //         ),
                //       ),
                //       colorScheme: ColorScheme.dark(
                //         primary: Colors.blue.shade200,
                //         surface: Colors.black, // Change the header color
                //         onPrimary: Colors.white, // Change the header text color
                //         onSurface: Colors.white, // Change the day text color
                //       ),
                //     ),
                //     child: child!,
                //   );
                // },
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
          ] else ...[
            _weekdaySelector(),
            const SizedBox(
              height: 20,
            ),

            // from time picker
            Text(
              "From Time: ${_fromTime != null ? _fromTime!.format(context) : 'No time selected'}",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            fabButton(context, () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _fromTime ?? TimeOfDay.now(),
              );
              if (picked != null) {
                setState(() => _fromTime = picked);
              }
            }, "Set From Time", 16),

            const SizedBox(height: 20),
            //to time picker
            Text(
              "To Time: ${_toTime != null ? _toTime!.format(context) : 'No time selected'}",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            fabButton(context, () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _toTime ?? TimeOfDay.now(),
              );
              if (picked != null) {
                setState(() => _toTime = picked);
              }
            }, "Set To Time", 16),
          ],

          const SizedBox(height: 60),
          fabButton(context, () {
            if (validateTaskFields()) {
              DateTime? dateTime;
              if (!isRecurring && _date != null && _time != null) {
                dateTime = DateTime(
                  _date!.year,
                  _date!.month,
                  _date!.day,
                  _time!.hour,
                  _time!.minute,
                );
              }

              TodoModel task = TodoModel(
                name: nameController.text,
                description: descController.text,
                date: dateTime ?? DateTime.now(),
                priority: isRecurring ? "" : _prior,
                isDone: isDone,
                notExpired: true,
                isRecurring: isRecurring,
                fromTime: _fromTime != null ? _fromTime!.format(context) : "",
                toTime: _toTime != null ? _toTime!.format(context) : "",
                selectedWeekdays: selectedWeekdays,
              );
              // print("Recurring task added: ${task.date}");
              // print("Recurring task added: ${task.isRecurring}");
              // print("Recurring task added: ${task.fromTime}");
              // print("Recurring task added: ${task.toTime}");
              // print("Recurring task added: ${task.selectedWeekdays}");
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
                print("Task Map: ${task.toMap()}");
              }
              resetDialogFields();
              Navigator.pop(context);
              showHeadsupNoti(context, ref, "Task saved successfully!");
            } else {
              showHeadsupNoti(context, ref, "Please fill in all fields!");
            }
          }, widget.taskToEdit != null ? "Update Task" : "Save Task", 0)
        ],
      ),
      // floatingActionButton: fabButton(context, () {
      //   if (validateTaskFields()) {
      //     DateTime dateTime = DateTime(
      //       _date!.year,
      //       _date!.month,
      //       _date!.day,
      //       _time!.hour,
      //       _time!.minute,
      //     );
      //     TodoModel task = TodoModel(
      //       name: nameController.text,
      //       description: descController.text,
      //       date: dateTime,
      //       priority: _prior,
      //       isDone: isDone,
      //       notExpired: true,
      //     );
      //     if (widget.taskToEdit != null) {
      //       // Update existing task
      //       ref.read(
      //         taskUpdateFullProvider(task),
      //       );
      //     } else {
      //       // Add new task
      //       ref.read(
      //         taskAddProvider(task),
      //       );
      //     }
      //     resetDialogFields();
      //     Navigator.pop(context);
      //   } else {
      //     print("error fields must not be empty");
      //   }
      // }, widget.taskToEdit != null ? "Update Task" : "Save Task", 26),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  Widget _dialogPrioritySelect(void Function(void Function()) setState) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<String>(
        showSelectedIcon: false,
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.fromLTRB(26, 26, 26, 26),
          ),
          textStyle:
              WidgetStatePropertyAll(Theme.of(context).textTheme.bodySmall),
        ),
        segments: <ButtonSegment<String>>[
          ButtonSegment<String>(
            value: 'High',
            label: Text('High'),
          ),
          ButtonSegment<String>(
            value: 'Medium',
            label: Text('Medium'),
          ),
          ButtonSegment<String>(
            value: 'Low',
            label: Text('Low'),
          ),
        ],
        selected: {localPrior},
        onSelectionChanged: (Set<String> value) {
          setState(
            () {
              localPrior = value.first;
              _prior = value.first;
            },
          );
        },
      ),
    );
  }

  Widget _isRecurringCheckBox() {
    return SwitchListTile(
      title: Text('Recurring Task?',
          style: Theme.of(context).textTheme.headlineSmall),
      value: isRecurring,
      onChanged: (value) {
        setState(() {
          isRecurring = value;
          if (isRecurring) {
            _date = null;
            _time = null;
            _prior = "";
          }
        });
      },
    );
  }

  Widget _weekdaySelector() {
    const List<String> weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    List<bool> isSelected = List.generate(
        7, (index) => selectedWeekdays.contains(index.toString()));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(weekdays.length, (index) {
        bool selected = selectedWeekdays.contains(weekdays[index]);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (selected) {
                selectedWeekdays.remove(weekdays[index]);
              } else {
                selectedWeekdays.add(weekdays[index]);
              }
            });
          },
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? Color(0xFFff8b2c) : Colors.grey.shade200,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                weekdays[index],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selected ? Colors.white : Colors.black,
                    ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
