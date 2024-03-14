import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
// File Service
//
// Manages file operations within the app. This includes uploading, downloading, storing, and storing files.
// It is primarily used for handling test templates and educational materials that users wish to work with in the app.

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class FileStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final List<Map<String, String>> _uploadedFiles = [];

  List<Map<String, String>> get uploadedFiles =>
      List.unmodifiable(_uploadedFiles);

  Future<void> uploadFile(String name, Uint8List bytes) async {
    try {
      // Create a reference to the file in Firebase Storage
      final ref = _storage.ref().child('files/$name');

      // Upload the file to Firebase Storage
      final uploadTask = ref.putData(bytes);

      // Wait for the upload to complete and get the download URL
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadURL = await snapshot.ref.getDownloadURL();

      // Store file metadata
      _uploadedFiles.add({'name': name, 'url': downloadURL});
    } catch (e) {
      // Handle any errors that occur during the upload process
      throw e;
    }
  }

  void deleteFile(String name) {
    // Placeholder for Firebase delete logic
    _uploadedFiles.removeWhere((file) => file['name'] == name);
  }
}
