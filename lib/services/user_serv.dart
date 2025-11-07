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
    });
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

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>(
  (ref) {
    return UserNotifier(ref);
  },
);

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  UserNotifier(Ref ref)
      : super(
          const AsyncValue.loading(),
        ) {
    loadUserDetails();
  }
  Future<void> loadUserDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        state = const AsyncValue.data(null);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        state = AsyncValue.data(
          UserModel.fromFirestore(doc.data()!),
        );
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e) {
      state = AsyncValue.error(
        e,
        StackTrace.current,
      );
    }
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
