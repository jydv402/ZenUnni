import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updateUserDesc(
    String about, String freeTime, String bedtime) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'about': about,
      'freeTime': freeTime,
      'bedtime': bedtime,
    });
  } catch (e) {
    throw Exception('Failed to update user details: $e');
  }
}

Future<void> saveUserDesc(String about, String freeTime, String bedtime) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {
        'about': about,
        'freeTime': freeTime,
        'bedtime': bedtime,
      },
      SetOptions(merge: true), // Ensures only new fields are added
    );
  } catch (e) {
    throw Exception('Failed to save user details: $e');
  }
}
