import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/zen_barrel.dart';

final userSearchProvider =
    StreamProvider.family<List<SearchModel>, String>((ref, query) {
  if (query.isEmpty) {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('score', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return SearchModel.fromMap(doc.data());
            }).toList());
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
