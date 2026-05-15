import 'package:get/get.dart';
import 'dart:developer';
import '../../../core/network/dio_client.dart';
import '../../../data/models/news_model.dart';

class NewsController extends GetxController {
  final _dio = DioClient().dio;

  final isLoading = false.obs;
  final news = <NewsModel>[].obs;
  final page = 1.obs;
  final total = 0.obs;
  final limit = 20;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews({bool refresh = false}) async {
    if (refresh) page.value = 1;
    isLoading.value = true;
    try {
      final res = await _dio.get('/api/news/get-list-active', queryParameters: {
        'key': '',
        'page': page.value,
        'limit': limit,
      });
      final raw = res.data;
      List<dynamic> list = raw is List ? raw : [];
      if (refresh || page.value == 1) {
        news.value = list.map((e) => NewsModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        news.addAll(list.map((e) => NewsModel.fromJson(e as Map<String, dynamic>)));
      }
      // Try get total from envelope (interceptor strips Data but Total stays on original)
      if (res.headers.value('x-total') != null) {
        total.value = int.tryParse(res.headers.value('x-total')!) ?? news.length;
      } else {
        total.value = news.length;
      }
    } catch (e) {
      log('NewsController.fetchNews error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
