import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zen/models/user_model.dart';

Future<void> createUserDoc(String username, int? gender, int? avt) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'username': username,
      'usernameLower': username.toLowerCase(),
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
      'score': 0,
      'gender': gender ?? 0,
      'avatar': avt ?? 0,
    }, SetOptions(merge: true));
  } catch (e) {
    throw Exception('Failed to create user document: $e');
  }
}

Future<void> updateUserDoc(String username, int gender, int avt) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
      {
        'username': username,
        'usernameLower': username.toLowerCase(),
        'gender': gender,
        'avatar': avt,
      },
    );
  } catch (e) {
    throw Exception('Failed to create user document: $e');
  }
}

final userNameProvider =
    AsyncNotifierProvider<UserNameNotifier, String?>(UserNameNotifier.new);

class UserNameNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data()?['username'] as String?;
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, UserModel?>(
  UserNotifier.new,
);

class UserNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists || doc.data() == null) return null;

    return UserModel.fromFirestore(doc.data()!);
  }
}

//Obtain all the usernames
final existingUsersProvider = StreamProvider<List<String>>(
  (ref) {
    //return only the doc
    return FirebaseFirestore.instance.collection('users').snapshots().map(
          (snapshot) => snapshot.docs.map(
            (doc) {
              return doc.data()['usernameLower'] as String;
            },
          ).toList(),
        );
  },
);
