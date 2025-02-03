import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moodProvider = StreamProvider<String?>((ref) async* {
  final moodDoc = FirebaseFirestore.instance.collection('mood');
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final querySnapshot = moodDoc
      .where('updatedOn', isGreaterThanOrEqualTo: today)
      .where('updatedOn', isLessThan: today.add(const Duration(days: 1)))
      .limit(1)
      .snapshots();

  await for (final snapshot in querySnapshot) {
    if (snapshot.docs.isNotEmpty) {
      yield snapshot.docs.first.data()['mood'] as String;
    } else {
      yield null;
    }
  }
});

final moodAddProvider = FutureProvider.autoDispose.family<void, String>(
  (ref, newMood) async {
    final moodDoc = FirebaseFirestore.instance.collection('mood');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final query = await moodDoc
        .where('updatedOn', isGreaterThanOrEqualTo: today)
        .where('updatedOn', isLessThan: today.add(const Duration(days: 1)))
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      // Update existing document
      final docId = query.docs.first.id;
      await moodDoc.doc(docId).update({'mood': newMood, 'updatedOn': now});
    } else {
      // Add new document
      await moodDoc.add({'mood': newMood, 'updatedOn': now});
    }
  },
);
