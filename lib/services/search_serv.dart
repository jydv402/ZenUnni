import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zen/zen_barrel.dart';

final rankedUserSearchProvider = StreamProvider<List<SearchModel>>((ref) {
  final username = ref.watch(userNameProvider).asData?.value ?? '';
  return ref.watch(userSearchProvider).when(
        data: (users) {
          int rank = 1;
          final rankedUsers = users.map(
            (user) {
              return SearchModel(
                username: user.username,
                score: user.score,
                rank: rank++,
                isUser: user.username == username,
                gender: user.gender,
                avatar: user.avatar,
              );
            },
          ).toList();
          return Stream.value(rankedUsers);
        },
        loading: () => Stream.value([]),
        error: (error, stackTrace) => Stream.error(error, stackTrace),
      );
});

final userSearchProvider = StreamProvider<List<SearchModel>>(
  (ref) {
    //return only the doc
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('score', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) {
              return SearchModel.fromMap(doc.data());
            },
          ).toList(),
        );
  },
);
