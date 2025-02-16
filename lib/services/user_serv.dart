import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createUserDoc(String username) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'username': username,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    throw Exception('Failed to create user document: $e');
  }
}

final userNameProvider = FutureProvider<String?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return doc.data()?['username'] as String?;
});
