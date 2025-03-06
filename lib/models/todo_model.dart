import 'package:cloud_firestore/cloud_firestore.dart';

final now = DateTime.now();

class TodoModel {
  //todo :change name to taskName
  String name;
  String description;
  DateTime date;
  String priority;
  bool isDone;
  final Function(bool?)? onChanged;
  //constructor
  TodoModel(
      {required this.name,
      required this.description,
      required this.date,
      required this.priority,
      required this.isDone,
      this.onChanged});

  Map<String, dynamic> toMap() {
    return {
      'task': name,
      'description': description,
      'date': date,
      'priority': priority,
      'isDone': isDone,
      //todo :'updatedOn': now
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      name: map['task'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      priority: map['priority'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }

  TodoModel copyWith({
    String? name,
    String? description,
    DateTime? date,
    String? priority,
    bool? isDone,
  }) {
    return TodoModel(
        name: name ?? this.name,
        description: description ?? this.description,
        date: date ?? this.date,
        priority: priority ?? this.priority,
        isDone: isDone ?? this.isDone);
  }
}
