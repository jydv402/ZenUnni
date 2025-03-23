class ScheduleItem {
  final String taskName;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;

  ScheduleItem({
    required this.taskName,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      taskName: json['taskName'],
      //priority: json['priority'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() => {
        'taskName': taskName,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'duration': duration,
      };
}
