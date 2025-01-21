import 'package:cloud_firestore/cloud_firestore.dart';

final moodDoc =
    FirebaseFirestore.instance.collection('mood'); //Get the mood collection
final now = DateTime.now();
final today = DateTime(now.year, now.month, now.day);

Future<void> addMoodToFirestore(String mood) async {
  // Check if a document for today already exists
  final query = await moodDoc
      .where('updatedOn', isGreaterThanOrEqualTo: today)
      .where('updatedOn', isLessThan: today.add(const Duration(days: 1)))
      .limit(1)
      .get();

  // If a document for today exists, query.docs will be non empty
  if (query.docs.isNotEmpty) {
    final docId = query.docs.first.id; //Get the document ID
    await moodDoc.doc(docId).update({
      'mood': mood,
      'updatedOn': now
    }); //Update the mood and updatedOn fields
  } else {
    // Document doesn't exist, create a new one
    await moodDoc.add({
      'mood': mood,
      'updatedOn': now,
    });
  }
}

Future<String> getMoodFromFirestore() async {
  // Check if a document for today already exists
  final query = await moodDoc
      .where('updatedOn', isGreaterThanOrEqualTo: today)
      .where('updatedOn', isLessThan: today.add(const Duration(days: 1)))
      .limit(1)
      .get();

  //Return the mood if the document exists
  return query.docs.first.data()['mood'];
}

Future<bool> checkMoodStatus() async {
  // Check if a document for today already exists
  final query = await moodDoc
      .where('updatedOn', isGreaterThanOrEqualTo: today)
      .where('updatedOn', isLessThan: today.add(const Duration(days: 1)))
      .limit(1)
      .get();

  //Return true if the document exists
  return query.docs.isNotEmpty;
}
