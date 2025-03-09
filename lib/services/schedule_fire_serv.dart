import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/models/schedule_model.dart';

final scheduleAddProvider =
    FutureProvider.autoDispose.family<void, List<ScheduleItem>>((ref, items) async {
  final String date = DateTime.now().toIso8601String();
  
  final FirebaseAuth auth = FirebaseAuth.instance;
  final scheduleDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .collection('schedule')
      .doc(date);

  await scheduleDoc.set({
    'date': date,
    'items': ScheduleItem.listToMap(items),
  });
});