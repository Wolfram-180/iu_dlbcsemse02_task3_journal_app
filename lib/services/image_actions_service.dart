import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef ImageID = String;

/// abstract class ImageUploadService used as parent for
/// exact Firebase-putFile action
abstract class ImageService {
  Future<ImageID?> uploadImageToRemote({
    required String filePath,
    required String userId,
    required String imageId,
  });

  Future<void> removeImageFromRemote({
    required String userId,
    required String entryId,
  });
}

/// Firebase-putFile action implementation
class FirebaseImageService implements ImageService {
  @override
  Future<ImageID?> uploadImageToRemote({
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

  @override
  Future<void> removeImageFromRemote(
      {required String userId, required String entryId}) async {
    // get docs by userId
    final collection =
        await FirebaseFirestore.instance.collection(userId).get();

    // find doc by id
    final firebaseEntry = collection.docs.firstWhere(
      (element) => element.id == entryId,
    );

    // remove image assigned with that entry
    try {
      await FirebaseStorage.instance
          .ref(userId)
          .child(firebaseEntry.id)
          .delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}
