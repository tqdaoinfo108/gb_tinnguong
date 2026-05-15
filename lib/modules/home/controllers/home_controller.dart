import 'dart:developer';
import 'package:get/get.dart';
import '../../../core/network/dio_client.dart';

class HomeController extends GetxController {
  final userName = ''.obs;
  final role = ''.obs;

  // Dashboard KPIs — populated from /api/statistics-dashboard-reports.
  final totalFacilities = 0.obs;
  final activeFacilities = 0.obs;
  final eventsToday = 0.obs;
  final pendingDocs = 0.obs;
  final isLoading = false.obs;

  final _dio = DioClient();

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    isLoading.value = true;
    try {
      final res = await _dio.dio.get('/api/statistics-dashboard-reports');
      final data = res.data;
      if (data is Map) {
        totalFacilities.value = (data['TotalOffice'] as num?)?.toInt() ?? 0;
        activeFacilities.value = (data['TotalOfficeActive'] as num?)?.toInt() ?? 0;
        eventsToday.value = (data['TotalEventToday'] as num?)?.toInt() ?? 0;
        pendingDocs.value = (data['TotalDocumentPending'] as num?)?.toInt() ?? 0;
      }
    } catch (e) {
      log('HomeController.fetchDashboard failed: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
