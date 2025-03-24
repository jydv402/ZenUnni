import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final now = DateTime.now();

class TodoModel {
  //todo :change name to taskName
  String name;
  String description;
  DateTime date;
  String priority;
  bool isDone;
  bool isRecurring;
  String fromTime;
  String toTime;
  List<String> selectedWeekdays;
  bool expired;
  final Function(bool?)? onChanged;
  //constructor
  TodoModel(
      {required this.name,
      required this.description,
      required this.date,
      required this.priority,
      required this.isDone,
      required this.isRecurring,
      required this.fromTime,
      required this.toTime,
      required this.selectedWeekdays,
      this.onChanged,
      required this.expired});


 // Convert TimeOfDay to String
  static String timeOfDayToString(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }


    // Convert String to TimeOfDay
  static TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
  Map<String, dynamic> toMap() {
    return {
      'task': name,
      'description': description,
      'date': date,
      'priority': priority,
      'isDone': isDone,
      'isRecurring':isRecurring,
      'fromTime':fromTime,
      'toTime':toTime,
      'selectedWeekdays':selectedWeekdays
      //todo :'updatedOn': now
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map, bool expired) {
    return TodoModel(
      name: map['task'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      priority: map['priority'] ?? '',
      isDone: map['isDone'] ?? false,
      isRecurring: map['isRecurring']??false,
      fromTime:map['fromTime'] ??'',
      toTime: map['toTime'] ?? '',
      selectedWeekdays: map['selectedWeekdays'] != null
          ? List<String>.from(map['selectedWeekdays'])
          : [],
      expired: expired,
    );
  }

  TodoModel copyWith({
    String? name,
    String? description,
    DateTime? date,
    String? priority,
    bool? isDone,
    String? fromTime,
    String? toTime,
    List<String>? selectedWeekdays,  
    bool? isRecurring,
  }) {
    return TodoModel(
        name: name ?? this.name,
        description: description ?? this.description,
        date: date ?? this.date,
        priority: priority ?? this.priority,
        isDone: isDone ?? this.isDone,
        isRecurring: isRecurring ?? this.isRecurring,
        fromTime: fromTime?? this.fromTime,
        toTime: toTime?? this.toTime,
        selectedWeekdays: selectedWeekdays?? this.selectedWeekdays,
        expired: expired);
  }


}
