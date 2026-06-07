import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:zen/zen_barrel.dart';
import 'package:zen/notification/notif.dart';

final editProvider = Provider<TodoModel?>((ref) => null);

// Task model Notifier
class TaskNotifier extends StreamNotifier<List<TodoModel>> {
  @override
  Stream<List<TodoModel>> build() async* {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final todoDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task')
        .where('isRecurring', isEqualTo: false);

    await for (final snapshot in todoDoc.snapshots()) {
      yield snapshot.docs.map((doc) {
        final data = doc.data();
        return TodoModel.fromMap(
          data,
          ((data['date'] as Timestamp?)?.toDate() ?? DateTime.now()).isAfter(
            DateTime.now(),
          ),
        );
      }).toList();
    }
  }

  Future<void> addTask(TodoModel task) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final taskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task');

    await taskDoc.add(task.toMap());

    if (!task.isRecurring && task.date.isAfter(DateTime.now())) {
      final notificationTime = task.date.subtract(const Duration(minutes: 10));
      if (notificationTime.isAfter(DateTime.now())) {
        await NotificationService.sheduleNotification(
          taskDoc.id.hashCode,
          "Task Reminder",
          "Your task '${task.name}' is due at ${DateFormat('hh:mm a').format(task.date)}.",
          notificationTime,
        );
      }
    }
  }

  Future<void> updateTask(TodoModel task) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final taskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task');

    final querySnapshot = await taskDoc
        .where('task', isEqualTo: task.oldname)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await taskDoc.doc(docId).update(task.toMap());

      if (!task.isRecurring && task.date.isAfter(DateTime.now())) {
        final notificationTime = task.date.subtract(
          const Duration(minutes: 10),
        );
        if (notificationTime.isAfter(DateTime.now())) {
          await NotificationService.sheduleNotification(
            taskDoc.id.hashCode,
            "Task Reminder",
            "Your updated task '${task.name}' is due at ${DateFormat('hh:mm a').format(task.date)}.",
            notificationTime,
          );
        }
      }
    }
  }

  Future<void> deleteTask(TodoModel task) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final taskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task');

    final querySnapshot = await taskDoc
        .where('task', isEqualTo: task.name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await taskDoc.doc(docId).delete();
    }
  }
}

final taskProvider = StreamNotifierProvider<TaskNotifier, List<TodoModel>>(() {
  return TaskNotifier();
});

// recurringTaskProvider
class RecurringTaskNotifier extends StreamNotifier<List<TodoModel>> {
  @override
  Stream<List<TodoModel>> build() async* {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final todoDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task')
        .where('isRecurring', isEqualTo: true);

    await for (final snapshot in todoDoc.snapshots()) {
      yield snapshot.docs.map((doc) {
        final data = doc.data();
        return TodoModel.fromMap(data, false);
      }).toList();
    }
  }

  Future<void> addTask(TodoModel task) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final taskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task');

    await taskDoc.add(task.toMap());
  }

  Future<void> updateTask(TodoModel task) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final taskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task');

    final querySnapshot = await taskDoc
        .where('task', isEqualTo: task.oldname)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await taskDoc.doc(docId).update(task.toMap());
    }
  }

  Future<void> deleteTask(TodoModel task) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final taskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task');

    final querySnapshot = await taskDoc
        .where('task', isEqualTo: task.name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await taskDoc.doc(docId).delete();
    }
  }
}

final recurringTaskProvider =
    StreamNotifierProvider<RecurringTaskNotifier, List<TodoModel>>(() {
      return RecurringTaskNotifier();
    });

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
        .where('isRecurring', isEqualTo: false)
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
        //print("Scheduled notification for: $taskName at $notificationTime");
      } else {
        //print("Skipped past-due task: $taskName");
      }
    }
  } catch (e) {
    //print("Error scheduling notifications: $e");
  }
}
