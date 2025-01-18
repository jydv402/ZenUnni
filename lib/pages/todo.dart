import 'package:flutter/material.dart';
import 'package:zen/pages/home_page.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  //function for displaying creation of a new task
  void _showTask(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
        builder: (BuildContext context) {
          String _currentprior = "";
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.all(30),
            title: const Text(
              "Add a new task",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    label: Text(
                      "Task name",
                      style: TextStyle(fontSize: 20),
                    ),
                    hintText: "Enter a name for your task"),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration:const  InputDecoration(
                    label: Text(
                      "Task description",
                      style: TextStyle(fontSize: 20),
                    ),
                    hintText: "Enter a name for your task"),
              ),
              const SizedBox(height: 25),
              //picking a date
              ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  child:const  Text("Select a date")),
              const SizedBox(height: 25),
              //picking a time
              ElevatedButton(
                  onPressed: () {
                    showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                  },
                  child: const Text("Select a time")),
              const SizedBox(height: 20),
              //to select priority of the task
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Select priority"),
                  DropdownButton(
                      iconSize: 30,
                      menuWidth: 100,
                      //menuMaxHeight: 10,
                      itemHeight: 50,
                      items: ['High', 'Medium', 'Low']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style:const  TextStyle(fontSize: 15),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentprior = newValue!;
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
                      Navigator.pop(context);
                    },
                    child:const Icon(
                      Icons.close,
                      size: 25,
                      color: Colors.red,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.check, size: 25, color: Colors.green),
                  ),
                ],
              )
            ],
          );
        });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const HomePage()));
                },
                icon: const Icon(Icons.arrow_back)),
          ],
        ),
        //to add details....
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
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
                    _showTask(context);
                  },
                  child: const Icon(Icons.add),
                ),
              )
            ],
          ),
        ));
  }
}
