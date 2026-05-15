import 'package:get/get.dart';
import 'dart:developer';
import '../../../core/network/dio_client.dart';
import '../../../data/models/information_model.dart';

class NotificationsController extends GetxController {
  final _dio = DioClient().dio;

  final isLoading = false.obs;
  final items = <InformationModel>[].obs;
  int get unreadCount => items.where((e) => !e.isRead).length;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final res = await _dio.get('/api/information/get-list', queryParameters: {
        'page': 1,
        'limit': 50,
      });
      final raw = res.data;
      List<dynamic> list = raw is List ? raw : [];
      items.value = list.map((e) => InformationModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      log('NotificationsController.fetchNotifications error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAllRead() async {
    items.value = items.map((e) => InformationModel(
      informationID: e.informationID,
      title: e.title,
      levelID: e.levelID,
      levelName: e.levelName,
      shortDescription: e.shortDescription,
      description: e.description,
      dateCreate: e.dateCreate,
      isRead: true,
      senderName: e.senderName,
      senderRole: e.senderRole,
    )).toList();
  }
}
