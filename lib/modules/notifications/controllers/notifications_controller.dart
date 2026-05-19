import 'package:get/get.dart';
import 'dart:developer';
import '../../../core/network/dio_client.dart';
import '../../../data/models/information_model.dart';

class NotificationsController extends GetxController {
  final _dio = DioClient().dio;

  final isLoading    = false.obs;
  final _allItems    = <InformationModel>[].obs;
  final total        = 0.obs;
  final page         = 1.obs;
  final limit        = 20;
  final hasMore      = true.obs;
  final selectedLevel = 0.obs; // 0=all, 1=Khẩn cấp, 2=Thông thường, 3=Thấp

  List<InformationModel> get items => _allItems;

  List<InformationModel> get filteredItems {
    if (selectedLevel.value == 0) return _allItems;
    return _allItems.where((e) => e.levelID == selectedLevel.value).toList();
  }

  int get unreadCount => _allItems.where((e) => !e.isRead).length;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool append = false}) async {
    if (!append) {
      page.value  = 1;
      hasMore.value = true;
    }
    isLoading.value = true;
    try {
      final res = await _dio.get('/api/information/get-list', queryParameters: {
        'page':     page.value,
        'limit':    limit,
        'statusID': -100,
      });
      final raw  = res.data;
      final list = raw is List
          ? raw
          : (raw is Map ? (raw['Data'] ?? raw['data'] ?? []) : <dynamic>[]);

      final fetched = (list as List)
          .map((e) => InformationModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (append) {
        _allItems.addAll(fetched);
      } else {
        _allItems.value = fetched;
      }

      final serverTotal = raw is Map ? (raw['Total'] as num?)?.toInt() : null;
      total.value = serverTotal ?? _allItems.length;
      hasMore.value = fetched.length >= limit;
    } catch (e) {
      log('NotificationsController.fetchNotifications error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadMore() {
    if (!isLoading.value && hasMore.value) {
      page.value++;
      fetchNotifications(append: true);
    }
  }

  @override
  Future<void> refresh() => fetchNotifications();

  void markAllRead() {
    _allItems.value = _allItems.map((e) => InformationModel(
      informationID:   e.informationID,
      title:           e.title,
      levelID:         e.levelID,
      levelName:       e.levelName,
      shortDescription: e.shortDescription,
      description:     e.description,
      dateCreate:      e.dateCreate,
      isRead:          true,
      senderName:      e.senderName,
      senderRole:      e.senderRole,
    )).toList();
  }
}
