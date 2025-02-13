import 'package:flutter/material.dart';
import 'package:zen/screens/home.dart';
import 'package:zen/services/task_serv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//where data of each task is stored when user is selecting options
class Task {
  String name;
  String description;
  DateTime date;
  String priority;
  //constructor
  Task({
    required this.name,
    required this.description,
    required this.date,
    required this.priority,
  });
}

class Todo extends ConsumerStatefulWidget {
  const Todo({super.key});

  @override
  ConsumerState<Todo> createState() => _TodoState();
}

class _TodoState extends ConsumerState<Todo> {
  //variables to store data
  DateTime? _date; //save date
  TimeOfDay? _time; //save time
  String _prior = ""; //save current prior
  List<Task> tasks = []; //to store the tasks in a list
  //controllers to pick up the info to be stored
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  //function that displays dialog box to select task details
  void _showTask(BuildContext context, Function addTaskCallback) {
    //clearing controllers so that dialog box looks new
    nameController.clear();
    descController.clear();
    showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
        builder: (BuildContext context) {
          DateTime? localDate;
          TimeOfDay? localTime;
          String localPrior = ""; //to display current prior on dialog
          return StatefulBuilder(
            //stateful builder to display updating elements
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                contentPadding: const EdgeInsets.all(30),
                title: const Text(
                  "Add a new task",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        label: Text(
                          "Task name",
                          style: TextStyle(fontSize: 20),
                        ),
                        hintText: "Enter a name for your task"),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                        label: Text(
                          "Task description",
                          style: TextStyle(fontSize: 20),
                        ),
                        hintText: "Enter a name for your task"),
                  ),
                  const SizedBox(height: 25),
                  //picking a date
                  ElevatedButton(
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
                      child: const Text("Select a date")),
                  const SizedBox(height: 15),
                  if (localDate != null)
                    Text(
                      "Selected Date: ${localDate!.year}-${localDate!.month.toString().padLeft(2, '0')}-${localDate!.day.toString().padLeft(2, '0')}", // Display selected date
                      style: const TextStyle(fontSize: 18),
                    )
                  else
                    const Text(
                      "No date selected currently", // Display fallback message if no date is selected
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  //picking a time
                  ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? picktime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (picktime != null) {
                          setState(() {
                            localTime = picktime; //saves to local variable
                            _time = picktime; //saves to global variable
                            print("Selected time: $localTime");
                          });
                        }
                      },
                      child: const Text("Select a time")),
                  const SizedBox(height: 20),
                  if (localTime != null)
                    Text(
                      "Selected Time: ${localTime!.hour}:${localTime!.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 18),
                    )
                  else
                    const Text(
                      "No time selected currently",
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  const SizedBox(height: 20),
                  //to select priority of the task
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Select priority"),
                      DropdownButton(
                          value: localPrior.isEmpty ? null : localPrior,
                          iconSize: 30,
                          menuWidth: 100,
                          //menuMaxHeight: 10,
                          itemHeight: 50,
                          dropdownColor: Colors.transparent,
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
                          underline: Container()),
                    ],
                  ),
                  const SizedBox(height: 90),
                  //to add buttons which confirms creation of a task or to discards

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          // X has been pressed so removing whatever has been stored
                          _date = null;
                          _time = null;
                          _prior = "";
                          nameController.text = "";
                          descController.text = "";
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          size: 25,
                          color: Colors.red,
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: (){

                          if (nameController.text.isNotEmpty &&
                              descController.text.isNotEmpty &&
                              _date != null &&
                              _time != null &&
                              _prior.isNotEmpty) {
                            setState(
                              () async{
              //this will combine both date and time into date_time
                                DateTime dateTime = DateTime(
                                    _date!.year,
                                    _date!.month,
                                    _date!.day,
                                    _time!.hour,
                                    _time!.minute);
                                //adding details to task model
                                Task task = Task(
                                    name: nameController.text,
                                    description: descController.text,
                                    date: dateTime,
                                    priority: _prior);
                                addTaskCallback(task);
                                
                                ref.read(taskAddProvider(task));
                                //setting the global variables to null
                                _date = null;
                                _time = null;
                                _prior = "";
                                nameController.text = "";
                                descController.text = "";
                                //debugging stuff can be removed later
                                print("new task has been added successfully");
                                for (var t in tasks) {
                                  print(
                                      "Task: ${t.name}, Description: ${t.description}, "
                                      "Date: ${t.date}, Priority: ${t.priority}");
                                }
                              },
                            );
                            Navigator.pop(context);
                          } else {
                            print("error fields must be null");
                          }
                        },
                        child: const Icon(Icons.check,
                            size: 25, color: Colors.green),
                      ),
                    ],
                  )
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("To-Do list",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LandPage()));
                },
                icon: const Icon(Icons.arrow_back)),
          ],
        ),
        //to add details....
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(tasks[index].name),
                      subtitle: Text(tasks[index].description),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 75,
                height: 75,
                child: FloatingActionButton(
                  onPressed: () {
                    _showTask(context, (Task task) {
                      setState(() {
                        tasks.add(task);
                      });
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              )
            ],
          ),
        ));
  }
}
