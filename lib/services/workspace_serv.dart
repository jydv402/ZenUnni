import 'package:workmanager/workmanager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';         
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zen/services/notif_serv.dart';
import 'package:zen/models/todo_model.dart';
import 'package:zen/firebase_options.dart';                

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
     
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      final FirebaseAuth auth = FirebaseAuth.instance;
      final userId = auth.currentUser?.uid;

      if (userId == null) {
        print("User is not logged in.");
        return Future.value(false);
      }

      final taskCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('task');

      final querySnapshot = await taskCollection.get();
      final tasks = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return TodoModel(
          name: data['task'] ?? '',
          description: data['description'] ?? '',
          date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
          priority: data['priority'] ?? '',
          isDone: data['isDone'] ?? false,
          expired: ((data['date'] as Timestamp?)?.toDate() ?? DateTime.now())
              .isAfter(DateTime.now()),
        );
      }).toList();

      
      final notifService = NotifServ();
      await notifService.initNotification();
      await notifService.scheduleNotificationsForTasks(tasks);

      print("Background task completed successfully");
      return Future.value(true);
    } catch (e) {
      print('Error in callbackDispatcher: $e');
      return Future.value(false);
    }
  });
}

void initializeBackgroundTask() {
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "taskCheck",
    "checkTasks",
    frequency: const Duration(minutes: 10),     // Runs every hour
    existingWorkPolicy: ExistingWorkPolicy.replace, 
  );
}
