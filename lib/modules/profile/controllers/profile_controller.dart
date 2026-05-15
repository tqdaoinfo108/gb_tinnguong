import 'dart:developer';
import 'package:get/get.dart';
import '../../../core/network/dio_client.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final userName = 'Đang tải...'.obs;
  final email = ''.obs;
  final isLoading = true.obs;
  final dioClient = DioClient();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await dioClient.dio.get('/api/user/profile');
      final data = response.data;
      if (data != null) {
        userName.value = data['FullName'] ?? data['UserName'] ?? 'Unknown';
        email.value = data['Email'] ?? data['GroupName'] ?? '';
      }
    } catch (e) {
      log('Error fetching profile: $e');
      userName.value = 'Lỗi kết nối';
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await dioClient.clearAuth();
    Get.offAllNamed(AppRoutes.login);
  }
}
