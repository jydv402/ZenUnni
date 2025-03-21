import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:zen/models/todo_model.dart';
import 'package:zen/zen_barrel.dart';

class NotifServ {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // Initialize notification settings
  Future<void> initNotification() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings();

    const settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await notificationsPlugin.initialize(settings);
    _isInitialized = true;
  }

  /// Notification details
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'task_reminder_channel',
        'Task Reminders',
        channelDescription: 'Reminders for pending tasks',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(sound: 'default',
      badgeNumber: 1, ),
    );
  }

  /// Show an instant notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    if (!_isInitialized) {
      await initNotification();
    }

    await notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  /// Schedule notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (!_isInitialized) {
      await initNotification();
    }

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Schedule notifications for multiple tasks
  Future<void> scheduleNotificationsForTasks(List<TodoModel> tasks) async {
    if (!_isInitialized) {
      await initNotification();
    }

    for (var task in tasks) {
      if (!task.isDone && isTaskDueSoon(task)) {
        await _scheduleNotification(task);
      }
    }
  }

  // Helper function to check if the task is due soon
bool isTaskDueSoon(TodoModel task) {
    final now = DateTime.now();
    if (task.date.isBefore(now)) return false;  // Prevent expired tasks
    final timeDifference = task.date.difference(now).inHours;
    return timeDifference <= 24;  // Due within 24 hours
}

  // Internal function to schedule individual task notifications
  Future<void> _scheduleNotification(TodoModel task) async {
    await notificationsPlugin.zonedSchedule(
      task.hashCode,
      "Task Reminder",
      "Your task '${task.name}' is due soon!",
      tz.TZDateTime.from(task.date, tz.local),
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}



//  await notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       notificationDetails(),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );