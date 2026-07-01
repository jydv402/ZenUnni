import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final scoreProvider = StreamProvider<int>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(0);
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) => doc.data()?['score'] as int? ?? 0);
});

final scoreIncrementProvider = FutureProvider.autoDispose.family<void, int>((
  ref,
  value,
) async {
  final user = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
    'score': FieldValue.increment(value),
  });
  ref.invalidate(scoreProvider); // Add this line to force refresh
});
