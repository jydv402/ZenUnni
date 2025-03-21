import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifServ {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isIntialized = false;

  bool get isInitialized => _isIntialized;

  Future<void> initNNotification() async {
    if (_isIntialized) return;

    const initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await notificationsPlugin.initialize(initSettings);
  }
  NotificationDetails notificationDetails() {
      return const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily_channel_id', 'DailyNotifications',
            channelDescription: 'Daily Notification Channel',
            importance: Importance.max,
            priority: Priority.high),
        iOS: DarwinNotificationDetails(),
      );
    }
  Future<void> showNotification({int id = 0,
  String? title,
  String? body,
  })async{
      return notificationsPlugin.show(id, title, body, NotificationDetails(),);
  }

}
