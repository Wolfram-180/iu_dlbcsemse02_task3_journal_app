import 'package:iu_dlbcsemse02_task3_journal_app/services/image_upload_service.dart';

class MockImageUploadService extends ImageUploadService {
  @override
  Future<ImageID?> uploadImage({
    required String filePath,
    required String userId,
    required String imageId,
  }) async =>
      'mock_image_id';
}
