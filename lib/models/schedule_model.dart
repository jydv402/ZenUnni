class ScheduleItem {
  final String taskName;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final String priority;
  final DateTime dueDate;

  ScheduleItem({
    required this.taskName,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.priority,
    required this.dueDate,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      taskName: json['taskName'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      duration: json['duration'],
      priority: json['priority'],
      dueDate: DateTime.parse(json['due_date']),
    );
  }

  Map<String, dynamic> toJson() => {
        'taskName': taskName,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'duration': duration,
        'priority': priority,
        'due_date': dueDate.toIso8601String(),
      };
}
