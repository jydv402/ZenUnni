import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //initialize flutter local notifications plugin

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {
        //TODO: handle notification interaction
      }

  //initialize
  static Future<void> init() async {
    //define android initialization settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/launcher_icon");

    //define the ios initialization settings
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    //combine android and ios initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    //Initialize the plugin with the specified settings
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    //request notification permission for android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  //show an instant notification
  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails("channel_ID", "channel_Name",
            importance: Importance.high, priority: Priority.high),
        iOS: DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  //show a schedule notification
  static Future<void> sheduleNotification(int id,
      String title, String body, DateTime scheduledDate) async {
    if(scheduledDate.isAfter(DateTime.now())){
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails("channel_ID", "channel_Name",
            importance: Importance.high, priority: Priority.high),
        iOS: DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body,//add notif id
        tz.TZDateTime.from(scheduledDate, tz.local), platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,matchDateTimeComponents: DateTimeComponents.dateAndTime);
    }
  }
}
