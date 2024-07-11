import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

typedef ImageID = String;

/// abstract class ImageUploadService used as parent for
/// exact Firebase-putFile action
abstract class ImageUploadService {
  Future<ImageID?> uploadImage({
    required String filePath,
    required String userId,
    required String imageId,
  });
}

/// Firebase-putFile action implementation
class FirebaseImageUploadService implements ImageUploadService {
  @override
  Future<ImageID?> uploadImage({
    required String filePath,
    required String userId,
    required String imageId,
  }) {
    final file = File(
      filePath,
    );

    /// journal entry image upload to FirebaseStorage
    return FirebaseStorage.instance
        .ref(userId)
        .child(imageId)
        .putFile(file)
        .then<ImageID?>((_) => imageId)
        .catchError((_) => null);
  }
}
