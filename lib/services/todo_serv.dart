import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zen/zen_barrel.dart';
import 'package:zen/notification/notif.dart';

// Task model
final taskProvider = StreamProvider<List<TodoModel>>(
  (ref) async* {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final todoDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task')
        .where('isRecurring', isEqualTo: false);

    //final querySnapshot = todoDoc.where('isDone', isEqualTo: false).snapshots();
    //maybe for reccuring tasks all we need is another stream provider with different querying condition

    await for (final snapshot in todoDoc.snapshots()) {
      final tasks = snapshot.docs.map((doc) {
        final data = doc.data();
        return TodoModel(
          name: data['task'] ?? '',
          description: data['description'] ?? '',
          date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
          priority: data['priority'] ?? '',
          isDone: data['isDone'] ?? false,
          isRecurring: data['isRecurring'] ?? false,
        //   expired: !data['isDone'] && 
        //  ((data['date'] as Timestamp?)?.toDate() ?? DateTime.now()) 
        //     .isBefore(DateTime.now()),
          expired: ((data['date'] as Timestamp?)?.toDate() ?? DateTime.now())
              .isAfter(DateTime.now()),
        );
      }).toList();
      yield tasks;
    }
  },
);

//recurringTaskProvider
final recurringTaskProvider = StreamProvider<List<TodoModel>>((ref) async* {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final todoDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .collection('task')
      .where('isRecurring', isEqualTo: true);

  await for (final snapshot in todoDoc.snapshots()) {
    final tasks = snapshot.docs.map((doc) {
      final data = doc.data();
      return TodoModel(
        name: data['task'] ?? '',
        description: data['description'] ?? '',
        date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
        priority: data['priority'] ?? '',
        isDone: data['isDone'] ?? false,
        isRecurring: data['isRecurring'] ?? true,
        expired: false,
      );
    }).toList();
    yield tasks;
  }
});

// Add task
final taskAddProvider = FutureProvider.autoDispose.family<void, TodoModel>(
  (ref, task) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final taskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task');

    // Add new document
    await taskDoc.add(
      task.toMap(),
    );

    // Schedule a notification for the newly added task
    if (!task.isRecurring && task.date.isAfter(DateTime.now())) {
      final notificationTime = task.date.subtract(Duration(minutes: 10));
      if (notificationTime.isAfter(DateTime.now())) {
        await NotificationService.sheduleNotification(
          taskDoc.id.hashCode,
          "Task Reminder",
          "Your task '${task.name}' is due at ${DateFormat('hh:mm a').format(task.date)}.",
          notificationTime,
        );
        print("Scheduled notification for: ${task.name} at $notificationTime");
      }
    }
  },
);

// Update full task
final taskUpdateFullProvider = FutureProvider.family<void, TodoModel>(
  (ref, task) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final taskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task');

    final querySnapshot =
        await taskDoc.where('task', isEqualTo: task.name).get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await taskDoc.doc(docId).update(
            task.toMap(),
          );
      // Schedule a notification for the updated task
      if (!task.isRecurring && task.date.isAfter(DateTime.now())) {
        final notificationTime = task.date.subtract(Duration(minutes: 10));
        if (notificationTime.isAfter(DateTime.now())) {
          await NotificationService.sheduleNotification(
            taskDoc.id.hashCode,
            "Task Reminder",
            "Your updated task '${task.name}' is due at ${DateFormat('hh:mm a').format(task.date)}.",
            notificationTime,
          );
          print(
              "Scheduled notification for updated task: ${task.name} at $notificationTime");
        }
      }
    }
  },
);

//Delete Task
final taskDeleteProvider = FutureProvider.family<void, TodoModel>(
  (ref, task) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final taskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task');

    // Query to find the document with matching task name
    final querySnapshot =
        await taskDoc.where('task', isEqualTo: task.name).get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await taskDoc.doc(docId).delete();
    }
  },
);

//to get the incomplete tasks to schedule notifications
Future<void> scheduleNotificationsForIncompleteTasks() async {
  try {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    // Fetch incomplete tasks
    final tasksSnapshot = await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task')
        .where('isDone', isEqualTo: false)
        .where('isRecurring',isEqualTo: false)
        .get();

    final now = DateTime.now();

    for (var doc in tasksSnapshot.docs) {
      final data = doc.data();
      final taskName = data['task'];
      final dueDate = (data['date'] as Timestamp).toDate();

      //  Cancel existing notification to prevent duplicates
      // await NotificationService.cancelNotification(taskId.hashCode);

      // Schedule notification 10 minutes before the due date
      final notificationTime = dueDate.subtract(Duration(minutes: 10));

      if (notificationTime.isAfter(now) && dueDate.isAfter(now)) {
        await NotificationService.sheduleNotification(
          doc.id.hashCode, // Unique ID based on task ID
          "Task Reminder",
          "Your task '$taskName' is due at ${DateFormat('hh:mm a').format(dueDate)}.",
          notificationTime,
        );
        print("Scheduled notification for: $taskName at $notificationTime");
      } else {
        print("Skipped past-due task: $taskName");
      }
    }
  } catch (e) {
    print("Error scheduling notifications: $e");
  }
}
