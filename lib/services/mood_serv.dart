import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addMoodToFirestore(String mood) async {
  final now = DateTime.now();
  await FirebaseFirestore.instance.collection('mood').add({
    'mood': mood,
    'updatedOn': now,
  });
}
