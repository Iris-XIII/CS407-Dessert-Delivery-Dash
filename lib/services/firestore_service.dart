import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserData(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
    return doc.data() as Map<String, dynamic>?;
  }
}
