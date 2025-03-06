class ScheduleItem {
  final String taskName;
  final String startTime;
  final String endTime;

  ScheduleItem({
    required this.taskName,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      taskName: json['taskName'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}
