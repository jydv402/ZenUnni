import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/zen_barrel.dart';

final habitProvider = StreamProvider<List<HabitModel>>((ref) async* {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final habitDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .collection('habit')
      .orderBy('createdAt', descending: true);

  await for (final snapshot in habitDoc.snapshots()) {
    final habit = snapshot.docs.map((doc) {
      final data = doc.data();
      return HabitModel(
        habitName: data['habitName'] ?? '',
        color: data['color'] ?? '',
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        completedDates:
            (data['completedDates'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(DateTime.parse(key), value as bool),
        ),
      );
    }).toList();
    yield habit;
  }
});

final habitAddProvider =
    FutureProvider.autoDispose.family<void, HabitModel>((ref, habit) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final habitDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .collection('habit');
  await habitDoc.add(
    habit.toMap(),
  );
});

final habitUpdateProvider = FutureProvider.autoDispose.family<void, HabitModel>(
  (ref, habit) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final habitDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('habit');

    final querySnapshot =
        await habitDoc.where('habitName', isEqualTo: habit.habitName).get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update(
        habit.toMap(),
      );
    } else {
      throw Exception('Habit Not Found');
    }
  },
);

final habitDeleteProvider = FutureProvider.autoDispose.family<void, HabitModel>(
  (ref, habit) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final habitDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('habit');

    final querySnapshot =
        await habitDoc.where('habitName', isEqualTo: habit.habitName).get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.delete();
    }
  },
);
