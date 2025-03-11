import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createUserDoc(String username) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'username': username,
      'usernameLower': username.toLowerCase(),
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
      'score': 0,
    });
  } catch (e) {
    throw Exception('Failed to create user document: $e');
  }
}

final userNameProvider =
    StateNotifierProvider<UserNameNotifier, AsyncValue<String?>>((ref) {
  return UserNameNotifier(ref);
});

class UserNameNotifier extends StateNotifier<AsyncValue<String?>> {
  UserNameNotifier(Ref ref)
      : super(
          const AsyncValue.loading(),
        ) {
    loadUserName();
  }
  Future<void> loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = const AsyncValue.data(null);
      return;
    }
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    //The user name is loaded into the app state
    //Why? To be passed to the AI chat
    state = AsyncValue.data(doc.data()?['username'] as String?);
  }
}
