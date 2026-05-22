import 'dart:developer';
import 'package:dio/dio.dart';
import '../models/map_layer_model.dart';

/// Truy vấn OpenStreetMap Overpass API để lấy POI theo danh mục + bounding box.
/// Free, không cần API key. Kết quả giới hạn 300 điểm / query.
///
/// Lý do dùng POST thay GET:
///   - Query string chứa ký tự đặc biệt ([, ], ", ;) → GET URL bị encode sai
///   - Overpass API trả 406 khi Accept header không khớp hoặc query bị corrupt
///   - POST + application/x-www-form-urlencoded là cách Overpass API khuyến nghị
class OverpassService {
  static final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        // Overpass trả JSON khi query có [out:json]; Accept phải cho phép nó
        'Accept': 'application/json, text/plain, */*',
        // Một số Overpass instance chặn request không có User-Agent
        'User-Agent': 'TinNguongApp/1.0 (Flutter; https://tinnguong.vn)',
      },
    ),
  );

  static const _endpoint = 'https://overpass-api.de/api/interpreter';

  static Future<List<PoiPoint>> fetchPoi({
    required PoiCategory category,
    required double south,
    required double west,
    required double north,
    required double east,
  }) async {
    try {
      final key   = category.overpassKey;
      final value = category.overpassValue;
      // bbox Overpass format: south,west,north,east
      final bbox  = '$south,$west,$north,$east';
      final query =
          '[out:json][timeout:20];'
          '(node["$key"="$value"]($bbox);'
          'way["$key"="$value"]($bbox););'
          'out center 300;';

      // POST + form-encoded — tránh 406 do URL encoding sai với GET
      final res = await _dio.post(
        _endpoint,
        data: 'data=${Uri.encodeQueryComponent(query)}',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.json,
        ),
      );

      final elements = (res.data['elements'] as List?) ?? [];
      return elements
          .map((e) {
            // node → lat/lon trực tiếp; way → center.lat/lon
            final lat =
                ((e['lat'] ?? e['center']?['lat']) as num?)?.toDouble() ?? 0.0;
            final lng =
                ((e['lon'] ?? e['center']?['lon']) as num?)?.toDouble() ?? 0.0;
            // Ưu tiên tên tiếng Việt nếu có
            final tags = e['tags'] as Map? ?? {};
            final name = (tags['name:vi'] ?? tags['name'] ?? '').toString();
            return PoiPoint(lat: lat, lng: lng, name: name);
          })
          .where((p) => p.lat != 0.0 && p.lng != 0.0)
          .toList();
    } catch (e) {
      log('OverpassService.fetchPoi(${category.name}) error: $e');
      return [];
    }
  }
}
