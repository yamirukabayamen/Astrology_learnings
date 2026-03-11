import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

import '../api_services/video_api.dart';
import '../model/video_model.dart';
import '../routes/SessionManger.dart';

class VideoController extends GetxController {

  var isLoading = false.obs;
  var isUploading = false.obs;
  var uploadProgress = 0.0.obs;
  var hasPaid = false.obs;
  var freeVideos = <VideoItem>[].obs;
  var entryVideos = <VideoItem>[].obs;
  var advanceVideos = <VideoItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  /// ================= FETCH VIDEOS =================
  Future<void> fetchVideos() async {
    try {
      isLoading.value = true;

      String? userId = await SessionManager.getUserId();

      if (userId == null) {
        debugPrint("User ID not found");
        return;
      }

      final response = await VideoApiService.fetchVideos(userId);

      if (response.success) {

        freeVideos.assignAll(
          response.type.expand((e) => e.videos).toList(),
        );

        entryVideos.assignAll(
          response.type2.expand((e) => e.videos).toList(),
        );

        advanceVideos.assignAll(
          response.type3.expand((e) => e.videos).toList(),
        );

        debugPrint("✅ Videos Fetched Successfully");
      } else {
        debugPrint("❌ API Failed: ${response.message}");
      }

    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= UPLOAD VIDEO =================
  Future<void> uploadVideo({
    required String videoUrl,
    required String type,
  }) async {

    debugPrint("========== VIDEO CONTROLLER UPLOAD START ==========");
    debugPrint("Video URL: $videoUrl");
    debugPrint("Type: $type");

    try {
      isUploading.value = true;

      final response = await VideoApiService.uploadVideoToBackend(
        videoUrl: videoUrl,
        type: type,
      );

      if (response is Map && response["success"] == true) {

        Get.snackbar("Success", response["message"]);

        /// 🔥 IMPORTANT → Refresh videos after upload
        await fetchVideos();

      } else {
        Get.snackbar("Failed", response["message"] ?? "Upload Failed");
      }

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isUploading.value = false;
      debugPrint("========== VIDEO CONTROLLER UPLOAD END ==========");
    }
  }

  /// ================= ADMIN FETCH =================
  Future<void> adminVideos(String userId) async {
    try {
      isLoading.value = true;

      final response = await VideoApiService.fetchVideos(userId);

      if (response.success) {
        freeVideos.assignAll(
            response.type.expand((e) => e.videos).toList());

        entryVideos.assignAll(
            response.type2.expand((e) => e.videos).toList());

        advanceVideos.assignAll(
            response.type3.expand((e) => e.videos).toList());
      }

    } catch (e) {
      debugPrint("Admin Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}