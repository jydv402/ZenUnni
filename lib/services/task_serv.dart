import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/screens/todo.dart';
import 'package:zen/models/todo_model.dart';

final taskProvider = StreamProvider<List<TaskModel>>((ref) async* {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final todoDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .collection('task');

  //final querySnapshot = todoDoc.where('isDone', isEqualTo: false).snapshots();

  await for (final snapshot in todoDoc.snapshots()) {
    final tasks = snapshot.docs.map((doc) {
      final data = doc.data();
      return TaskModel(
        name: data['task'] ?? '',
        description: data['description'] ?? '',
        date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
        priority: data['priority'] ?? '',
        isDone: data['isDone'] ?? false,
      );
    }).toList();
    yield tasks;
  }
});

final taskAddProvider =
    FutureProvider.autoDispose.family<void, TaskModel>((ref, task) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final taskDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .collection('task');

  // Add new document
  await taskDoc.add(task.toMap());
});

final taskUpdateProvider = FutureProvider.family<void, TaskModel>((ref, task) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final taskDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .collection('task');

  // Query to find the document with matching task name
  final querySnapshot = await taskDoc.where('task', isEqualTo: task.name).get();

  if (querySnapshot.docs.isNotEmpty) {
    final docId = querySnapshot.docs.first.id;
    await taskDoc.doc(docId).update({
      'isDone': task.isDone,
    });
  }
});
