import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final scoreProvider = StreamProvider<int>((ref) async* {
  final user = FirebaseAuth.instance.currentUser;
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
  yield doc.data()?['score'] as int;
});

final scoreIncrementProvider =
    FutureProvider.autoDispose.family<void, int>((ref, value) async {
  final user = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .update({'score': FieldValue.increment(value)});
});
