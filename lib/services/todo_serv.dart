import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zen/zen_barrel.dart';

final editProvider = StateProvider<TodoModel?>((ref) => null);

// Task model
final taskProvider = StreamProvider<List<TodoModel>>(
  (ref) async* {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final todoDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('task');

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
          expired: ((data['date'] as Timestamp?)?.toDate() ?? DateTime.now())
              .isAfter(DateTime.now()),
        );
      }).toList();
      yield tasks;
    }
  },
);

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
