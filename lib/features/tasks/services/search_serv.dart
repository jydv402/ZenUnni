import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/features/profile/services/user_serv.dart';
import 'package:zen/features/gamification/services/gamify_serve.dart';
import 'package:zen/features/tasks/models/search_model.dart';

final rankedUserSearchProvider = StreamProvider<List<SearchModel>>((ref) {
  final username = ref.watch(userNameProvider).value ?? '';
  return ref
      .watch(userSearchProvider)
      .when(
        data: (users) {
          int rank = 1;
          final rankedUsers = users.map((user) {
            return SearchModel(
              username: user.username,
              score: user.score,
              rank: rank++,
              isUser: user.username == username,
              gender: user.gender,
              avatar: user.avatar,
            );
          }).toList();
          return Stream.value(rankedUsers);
        },
        loading: () => Stream.value([]),
        error: (error, stackTrace) => Stream.error(error, stackTrace),
      );
});

final userSearchProvider = StreamProvider<List<SearchModel>>((ref) {
  // Return top 50 users sorted by score to limit download sizes
  return FirebaseFirestore.instance
      .collection('users')
      .orderBy('score', descending: true)
      .limit(50)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map((doc) {
          return SearchModel.fromMap(doc.data());
        }).toList(),
      );
});

// Highly efficient ranking provider using count query
final currentUserRankProvider = FutureProvider<int>((ref) async {
  final score = ref.watch(scoreProvider).value ?? 0;
  final countSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('score', isGreaterThan: score)
      .count()
      .get();
  return (countSnapshot.count ?? 0) + 1;
});

// Search query state managed via modern Notifier
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final userSearchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

// On-demand prefix-based search results
final userSearchResultsProvider = FutureProvider<List<SearchModel>>((
  ref,
) async {
  final query = ref.watch(userSearchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) {
    return const [];
  }
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('usernameLower', isGreaterThanOrEqualTo: query)
      .where('usernameLower', isLessThanOrEqualTo: '$query\uf8ff')
      .limit(20)
      .get();

  return snapshot.docs.map((doc) => SearchModel.fromMap(doc.data())).toList();
});
