import 'dart:developer';
import '../../core/network/dio_client.dart';
import '../models/event_model.dart';
import '../models/dropdown_models.dart';
import '../models/office_model.dart';

class EventService {
  final _dio = DioClient().dio;

  // ── List active ───────────────────────────────────────────────
  // GET /api/event/get-list-active?dtFrom=...&dtTo=...&page=1&limit=20
  // dtFrom & dtTo are REQUIRED by the server (omitting them causes 404).
  // Default: last 2 years → next 1 year to fetch all relevant events.
  Future<({List<EventModel> items, int total})> getListActive({
    DateTime? dtFrom,
    DateTime? dtTo,
    int page = 1,
    int limit = 20,
  }) async {
    final now = DateTime.now();
    final params = <String, dynamic>{
      'dtFrom': _fmtDt(dtFrom ?? DateTime(now.year - 2, 1, 1)),
      'dtTo':   _fmtDt(dtTo   ?? DateTime(now.year + 1, 12, 31, 23, 59, 59)),
      'page':   page,
      'limit':  limit,
    };

    final res = await _dio.get('/api/event/get-list-active', queryParameters: params);
    final raw = res.data;

    // DioClient unwraps Data automatically; raw may be List or Map
    final list = raw is List
        ? raw
        : (raw is Map ? (raw['Data'] ?? raw['data'] ?? []) : <dynamic>[]);

    final items = (list as List)
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final serverTotal = raw is Map
        ? (raw['Total'] as num?)?.toInt()
        : null;

    return (items: items, total: serverTotal ?? items.length);
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

  // ── Dropdowns ─────────────────────────────────────────────────
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

  // ── Utils ─────────────────────────────────────────────────────
  static String _fmtDt(DateTime d) {
    final y  = d.year;
    final mo = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    final ss = d.second.toString().padLeft(2, '0');
    return '$y-$mo-$dd $hh:$mm:$ss';
  }
}
