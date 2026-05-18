import 'dart:developer';
import 'package:get/get.dart';
import '../../../core/network/dio_client.dart';
import '../../../data/models/news_model.dart';

class NewsController extends GetxController {
  final _dio = DioClient().dio;

  // ── State ─────────────────────────────────────────────────────
  final isLoading = false.obs;
  final _allNews  = <NewsModel>[].obs;
  final total     = 0.obs;
  final page      = 1.obs;
  final limit     = 20;
  final hasMore   = true.obs;

  // ── Client-side search ────────────────────────────────────────
  final searchKey = ''.obs;

  List<NewsModel> get news {
    final q = searchKey.value.trim().toLowerCase();
    if (q.isEmpty) return _allNews;
    return _allNews
        .where((n) => n.title.toLowerCase().contains(q) ||
            (n.description ?? '').toLowerCase().contains(q))
        .toList();
  }

  // ── Lifecycle ─────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  // ── Fetch ─────────────────────────────────────────────────────
  Future<void> fetchNews({bool append = false}) async {
    if (!append) {
      page.value = 1;
      hasMore.value = true;
    }
    isLoading.value = true;
    try {
      final res = await _dio.get('/api/news/get-list-active', queryParameters: {
        'page':  page.value,
        'limit': limit,
      });

      final raw  = res.data;
      final list = raw is List
          ? raw
          : (raw is Map ? (raw['Data'] ?? raw['data'] ?? []) : <dynamic>[]);

      final items = (list as List)
          .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (append) {
        _allNews.addAll(items);
      } else {
        _allNews.value = items;
      }

      final serverTotal = raw is Map ? (raw['Total'] as num?)?.toInt() : null;
      total.value = serverTotal ?? _allNews.length;
      hasMore.value = items.length >= limit;
    } catch (e) {
      log('NewsController.fetchNews error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadMore() {
    if (!isLoading.value && hasMore.value) {
      page.value++;
      fetchNews(append: true);
    }
  }

  Future<void> refresh() => fetchNews();
}
