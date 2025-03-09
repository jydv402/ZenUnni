class ScheduleItem {
  final String taskName;
  final String priority;
  final String startTime;
  final String endTime;

  ScheduleItem({
    required this.taskName,
    required this.priority,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      taskName: json['taskName'],
      priority: json['priority'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
      'priority': priority,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  static List<Map<String, dynamic>> listToMap(List<ScheduleItem> items) {
    return items.map((item) => item.toMap()).toList();
  }
}
