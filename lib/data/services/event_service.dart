import 'dart:developer';
import '../../core/network/dio_client.dart';
import '../models/event_model.dart';
import '../models/dropdown_models.dart';
import '../models/office_model.dart';

class EventService {
  final _dio = DioClient().dio;

  // ── List ──────────────────────────────────────────────────────
  Future<({List<EventModel> items, int total})> getList({
    String key = ' ',
    int statusID = -100,
    int page = 1,
    int limit = 20,
  }) async {
    final res = await _dio.get('/api/event/get-list', queryParameters: {
      'key': key.isEmpty ? ' ' : key,
      'IsActivity': true,
      'statusID': statusID,
      'page': page,
      'limit': limit,
    });
    final raw = res.data;
    final list = raw is List ? raw : (raw is Map ? raw['Data'] ?? raw['data'] ?? [] : []);
    final items = (list as List)
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final total = raw is Map ? (raw['Total'] as num?)?.toInt() ?? items.length : items.length;
    return (items: items, total: total);
  }

  // ── Create ────────────────────────────────────────────────────
  Future<void> create(Map<String, dynamic> payload) async {
    await _dio.post('/api/event/create-event', data: payload);
  }

  // ── Update ────────────────────────────────────────────────────
  Future<void> update(Map<String, dynamic> payload) async {
    await _dio.post('/api/event/update-event', data: payload);
  }

  // ── Delete ────────────────────────────────────────────────────
  Future<void> delete(int eventID) async {
    await _dio.post('/api/event/delete-event', data: {'EventID': eventID});
  }

  // ── Dropdowns (parallel-safe, each returns empty list on error) ──
  Future<List<TypeEventModel>> getTypeEvents() async {
    try {
      final res = await _dio.get('/api/type-event/get-list-active');
      final raw = res.data;
      final list = raw is List ? raw : <dynamic>[];
      return list.map((e) => TypeEventModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      log('getTypeEvents error: $e');
      return [];
    }
  }

  Future<List<VillageModel>> getVillages() async {
    try {
      final res = await _dio.get('/api/village/get-list-active');
      final raw = res.data;
      final list = raw is List ? raw : <dynamic>[];
      return list.map((e) => VillageModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      log('getVillages error: $e');
      return [];
    }
  }

  Future<List<OfficeModel>> getOffices() async {
    try {
      final res = await _dio.get('/api/office/get-list', queryParameters: {'limit': 500});
      final raw = res.data;
      final list = raw is List ? raw : <dynamic>[];
      return list.map((e) => OfficeModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      log('getOffices error: $e');
      return [];
    }
  }
}
