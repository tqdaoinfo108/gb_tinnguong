import 'dart:developer';
import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/office_model.dart';
import '../models/religion_model.dart';
import '../models/class_data_model.dart';
import '../models/city_model.dart';
import '../models/banner_model.dart';
import '../models/event_model.dart';
import '../models/event_album_model.dart';

/// Tất cả API calls cho module Bản đồ GIS.
class MapService {
  final _dio = DioClient();

  // ─── 1A. Load markers ──────────────────────────────────────────
  Future<List<OfficeModel>> getOfficeList() async {
    try {
      final res = await _dio.dio.get(
        '/api/office/get-list',
        queryParameters: {
          'statusID': -100,
          'page': 1,
          'limit': 500,
        },
      );
      final raw = res.data;
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(OfficeModel.fromJson)
            .toList();
      }
      return [];
    } catch (e) {
      log('MapService.getOfficeList failed: $e');
      return [];
    }
  }

  // ─── 1B. Filter panel ──────────────────────────────────────────
  Future<List<ReligionModel>> getReligionListActive() async {
    try {
      final res = await _dio.dio.get('/api/religion/get-list-active');
      final raw = res.data;
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(ReligionModel.fromJson)
            .toList();
      }
      return [];
    } catch (e) {
      log('MapService.getReligionListActive failed: $e');
      return [];
    }
  }

  Future<List<ClassDataModel>> getClassDataListActive() async {
    try {
      final res = await _dio.dio.get('/api/class-data/get-list-active');
      final raw = res.data;
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(ClassDataModel.fromJson)
            .toList();
      }
      return [];
    } catch (e) {
      log('MapService.getClassDataListActive failed: $e');
      return [];
    }
  }

  // ─── 1C. Boundary polygon ─────────────────────────────────────
  Future<CityModel?> getCityDefault() async {
    try {
      final res = await _dio.dio.get('/api/city/get-default');
      final raw = res.data;
      if (raw is Map<String, dynamic>) {
        return CityModel.fromJson(raw);
      }
      return null;
    } catch (e) {
      log('MapService.getCityDefault failed: $e');
      return null;
    }
  }

  Future<List<CityPointModel>> getCityPoints(int cityID) async {
    try {
      final res = await _dio.dio.get(
        '/api/city-point/get-list',
        queryParameters: {
          'cityID': cityID,
          'page': 1,
          'limit': 1000,
        },
      );
      final raw = res.data;
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(CityPointModel.fromJson)
            .toList();
      }
      return [];
    } catch (e) {
      log('MapService.getCityPoints failed: $e');
      return [];
    }
  }

  // ─── 2A. Banner (ảnh bìa / tài liệu) ─────────────────────────
  Future<List<BannerModel>> getBannersByType({
    required int officeID,
    required int typeBannerID,
  }) async {
    try {
      final res = await _dio.dio.get(
        '/api/banner/get-by-type',
        queryParameters: {
          'officeID': officeID,
          'typeBannerID': typeBannerID,
          'statusID': 1,
          'page': 1,
          'limit': 100,
        },
      );
      final raw = res.data;
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(BannerModel.fromJson)
            .toList();
      }
      return [];
    } catch (e) {
      log('MapService.getBannersByType failed: $e');
      return [];
    }
  }

  // ─── 2B. Events + Albums ───────────────────────────────────────
  Future<List<EventModel>> getEventList(int officeID) async {
    try {
      final res = await _dio.dio.get(
        '/api/event/get-list',
        queryParameters: {
          'officeID': officeID,
          'IsActivity': true,
          'statusID': -100,
          'page': 1,
          'limit': 100,
        },
      );
      final raw = res.data;
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(EventModel.fromJson)
            .toList();
      }
      return [];
    } catch (e) {
      log('MapService.getEventList failed: $e');
      return [];
    }
  }

  Future<List<EventAlbumModel>> getEventAlbums(int eventID) async {
    try {
      final res = await _dio.dio.get(
        '/api/event-album/get-list',
        queryParameters: {
          'eventID': eventID,
          'statusID': -100,
          'page': 1,
          'limit': 50,
        },
      );
      final raw = res.data;
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(EventAlbumModel.fromJson)
            .toList();
      }
      return [];
    } catch (e) {
      log('MapService.getEventAlbums failed: $e');
      return [];
    }
  }

  Future<List<AlbumImageModel>> getAlbumImages(int eventAlbumID) async {
    try {
      final res = await _dio.dio.get(
        '/api/album-image/get-list',
        queryParameters: {
          'EventAlbumID': eventAlbumID,
          'page': 1,
          'limit': 100,
        },
      );
      final raw = res.data;
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(AlbumImageModel.fromJson)
            .toList();
      }
      return [];
    } catch (e) {
      log('MapService.getAlbumImages failed: $e');
      return [];
    }
  }

  // ─── 3. Xem hồ sơ ─────────────────────────────────────────────
  Future<OfficeModel?> getOfficeById(int officeID) async {
    try {
      final res = await _dio.dio.get(
        '/api/office/get-by-id',
        queryParameters: {'ID': officeID},
      );
      final raw = res.data;
      if (raw is Map<String, dynamic>) {
        return OfficeModel.fromJson(raw);
      }
      return null;
    } catch (e) {
      log('MapService.getOfficeById failed: $e');
      return null;
    }
  }

  // ─── 4. OSRM Routing ──────────────────────────────────────────
  /// Lấy route từ OSRM free server.
  /// Returns list of [lat, lng] points cho polyline.
  Future<List<List<double>>> getOsrmRoute({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) async {
    try {
      final url =
          'https://router.project-osrm.org/route/v1/driving/$fromLng,$fromLat;$toLng,$toLat?overview=full&geometries=geojson';
      final dio = Dio();
      final res = await dio.get(url);
      final data = res.data;
      if (data is Map<String, dynamic>) {
        final routes = data['routes'] as List?;
        if (routes != null && routes.isNotEmpty) {
          final geometry = routes[0]['geometry'] as Map<String, dynamic>?;
          if (geometry != null) {
            final coords = geometry['coordinates'] as List?;
            if (coords != null) {
              // GeoJSON is [lng, lat], convert to [lat, lng]
              return coords
                  .map<List<double>>((c) => [
                        (c[1] as num).toDouble(),
                        (c[0] as num).toDouble(),
                      ])
                  .toList();
            }
          }
        }
      }
      return [];
    } catch (e) {
      log('MapService.getOsrmRoute failed: $e');
      return [];
    }
  }
}
