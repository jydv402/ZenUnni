import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/screens/todo.dart';
import 'package:zen/services/ai.dart';


final taskProvider = StreamProvider<String?>((ref) async* {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final moodDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .collection('task');
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // check if this is the condiion
  final querySnapshot = moodDoc
      .where('updatedOn', isGreaterThanOrEqualTo: today)
      .where('updatedOn', isLessThan: today.add(const Duration(days: 1)))
      .limit(1)
      .snapshots();

  await for (final snapshot in querySnapshot) {
    if (snapshot.docs.isNotEmpty) {
      yield snapshot.docs.first.data()['task'] as String;
    } else {
      yield null;
    }
  }
});


final taskAddProvider = FutureProvider.autoDispose.family<void,Task>(
  (ref, task) async{
    print(task);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final taskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

     final query = await taskDoc
        .where('updatedOn', isGreaterThanOrEqualTo: today)
        .where('updatedOn', isLessThan: today.add(const Duration(days: 1)))
        .limit(1)
        .get();

        final taskData = {
          'name':task.name,
          'description':task.description,
          'date': task.date,
          'priority':task.priority,
          'updatedOn':DateTime.now(),
        };

   if (query.docs.isNotEmpty) {
      // Update existing document
      final docId = query.docs.first.id;
      await taskDoc.doc(docId).update(taskData);
    } else {
      // Add new document
      await taskDoc.add(taskData);
    }

  }
);