import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/models/search_model.dart';

final userSearchProvider = StreamProvider.family<List<SearchModel>, String>((ref, query) {
  if (query.isEmpty) {
    return Stream.value([]);
  }

  String lowerQuery = query.toLowerCase();

  return FirebaseFirestore.instance
      .collection('users')
      .orderBy('usernameLower')
      .startAt([lowerQuery])
      .endAt(["$lowerQuery\uf8ff"])
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            return SearchModel.fromMap(doc.data());
          }).toList());
});
