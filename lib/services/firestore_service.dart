import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  // Singleton
  FirestoreService._();
  static final instance = FirestoreService._();

  // READ METHODS
  // get a stream of the user's profile for updates in the UI
  Stream<Player> streamPlayer(String userId) {
    return _db.collection(_usersCollection).doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Player.fromMap(snapshot.data()!, snapshot.id);
      }
      // return default profile if no data
      return Player(userId: userId);
    });
  }

  // WRITE METHODS
  // create a new player profile
  Future<void> initializePlayer(Player profile) async {
    await _db.collection(_usersCollection).doc(profile.userId).set(
        profile.toMap(),
        SetOptions(merge: true),
    );
  }

  // update Money
  Future<void> updatePlayerMoney(String userId, double newMoney) async {
    await _db.collection(_usersCollection).doc(userId).update({
      'money': newMoney,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // update Day
  Future<void> updatePlayerDay(String userId, int newDayNumber) async {
    await _db.collection(_usersCollection).doc(userId).update({
      'dayNumber': newDayNumber,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }
}
