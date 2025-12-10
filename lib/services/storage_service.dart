import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Singleton
  StorageService._();
  static final instance = StorageService._();

  /// Uploads a file and returns the public download URL
  Future<String> uploadProfilePhoto({
    required String userId,
    required String localFilePath,
  }) async {
    // Path: user_photos/{userId}/profile_photo.jpg
    final storageRef = _storage.ref().child('user_photos').child(userId).child('profile_photo.jpg');

    final uploadTask = storageRef.putFile(File(localFilePath));
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}