import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String habitName;
  final String color;
  final DateTime createdAt;
  final Map<DateTime, bool> completedDates;

  HabitModel({
    required this.habitName,
    required this.color,
    required this.createdAt,
    required this.completedDates,
  });


  Map<String, dynamic> toMap() {
    return {
      'habitName': habitName,
      'color': color,
      'createdAt': Timestamp.fromDate(createdAt), 
      'completedDates': completedDates.map(
        (key, value) => MapEntry(key.toIso8601String(), value), 
      ),
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      habitName: map['habitName'] ?? '',
      color: map['color'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(), 
      completedDates: (map['completedDates'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(DateTime.parse(key), value as bool),
      ),
    );
  }
}