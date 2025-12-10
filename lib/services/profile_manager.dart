import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/progress_repository.dart';

class ProfileManager extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProgressRepository _repository = ProgressRepository();

  UserProgress _progress = UserProgress(day: 1, money: 0);
  UserProgress get progress => _progress;

  int get money => _progress.money;
  int get dayNumber => _progress.day;

  // listens to the Firebase Auth state
  void initialize() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadProgress(user.uid);
      } else {
        _progress = UserProgress(day: 1, money: 0);
        notifyListeners(); // Notify UI of logged-out state
      }
    });
  }

  // loads progress
  Future<void> _loadProgress(String userId) async {
    try {
      // Use your existing repository method
      _progress = await _repository.loadProgress(userId);
      notifyListeners();
    } catch (e) {
      print("Error loading progress: $e");
    }
  }

  // Money Logic
  Future<void> addMoney(int amount) async {
    final user = _auth.currentUser;
    if (user == null || amount <= 0) return;

    // Calculate new state
    final int newMoney = _progress.money + amount;

    // Create new state object
    _progress = UserProgress(day: _progress.day, money: newMoney);

    // Immediately update repository (saves to Firestore)
    await _repository.saveProgress(
      uid: user.uid,
      day: _progress.day,
      money: newMoney,
    );

    notifyListeners(); // Tell the UI to rebuild
  }

  // Advance day logic
  Future<void> advanceDay() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final int newDay = _progress.day + 1;

    // Create new state object
    _progress = UserProgress(day: newDay, money: _progress.money);

    // Immediately update repository (saves to Firestore)
    await _repository.saveProgress(
      uid: user.uid,
      day: newDay,
      money: _progress.money,
    );

    notifyListeners();
  }
}