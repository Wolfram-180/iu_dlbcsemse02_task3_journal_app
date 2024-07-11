import 'package:iu_dlbcsemse02_task3_journal_app/services/image_actions_service.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/extensions/if_debugging.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class MockImageUploadService extends ImageService {
  @override
  Future<ImageID?> uploadImageToRemote({
    required String filePath,
    required String userId,
    required String imageId,
  }) async =>
      'mock_image_id';

  @override
  Future<void> removeImageFromRemote(
      {required String userId, required String entryId}) async {
    if (kDebugMode) print('image removed'.ifDebugging);
  }
}
