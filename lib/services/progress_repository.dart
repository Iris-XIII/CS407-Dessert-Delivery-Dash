import 'package:cloud_firestore/cloud_firestore.dart';

class UserProgress {
  final int day;
  final int money;

  UserProgress({
    required this.day,
    required this.money,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'money': money,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserProgress.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      // default progress for new user
      return UserProgress(day: 1, money: 0);
    }

    return UserProgress(
      day: (data['day'] ?? 1) as int,
      money: (data['money'] ?? 0) as int,
    );
  }
}

class ProgressRepository {
  final _db = FirebaseFirestore.instance;
  final String collectionPath;

  ProgressRepository({this.collectionPath = 'userProgress'});

  Future<UserProgress> loadProgress(String uid) async {
    final doc = await _db.collection(collectionPath).doc(uid).get();
    return UserProgress.fromDoc(doc);
  }

  Future<void> saveProgress({
    required String uid,
    required int day,
    required int money,
  }) async {
    final progress = UserProgress(day: day, money: money);
    await _db.collection(collectionPath).doc(uid).set(
      progress.toMap(),
      SetOptions(merge: true),
    );
  }
}
