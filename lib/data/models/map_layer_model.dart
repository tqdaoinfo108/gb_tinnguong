import 'package:flutter/material.dart';

// ─── Base tile layers ─────────────────────────────────────────────────────────

enum MapBaseLayer { administrative, terrain, satellite, hybrid }

extension MapBaseLayerX on MapBaseLayer {
  String get label => switch (this) {
        MapBaseLayer.administrative => 'Hành chính',
        MapBaseLayer.terrain        => 'Địa hình',
        MapBaseLayer.satellite      => 'Vệ tinh',
        MapBaseLayer.hybrid         => 'Vệ tinh + Nhãn',
      };

  String get description => switch (this) {
        MapBaseLayer.administrative => 'Tên đường, khu vực',
        MapBaseLayer.terrain        => 'Đường đồng mức, địa lý',
        MapBaseLayer.satellite      => 'Ảnh vệ tinh thuần',
        MapBaseLayer.hybrid         => 'Ảnh vệ tinh + tên đường',
      };

  IconData get icon => switch (this) {
        MapBaseLayer.administrative => Icons.map_outlined,
        MapBaseLayer.terrain        => Icons.terrain_rounded,
        MapBaseLayer.satellite      => Icons.satellite_alt_rounded,
        MapBaseLayer.hybrid         => Icons.layers_rounded,
      };

  // Tile URL chính
  String get tileUrl => switch (this) {
        MapBaseLayer.administrative =>
            'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
        MapBaseLayer.terrain =>
            'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
        MapBaseLayer.satellite =>
            'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
        MapBaseLayer.hybrid =>
            'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
      };

  List<String>? get subdomains => switch (this) {
        MapBaseLayer.administrative => const ['a', 'b', 'c', 'd'],
        MapBaseLayer.terrain        => const ['a', 'b', 'c'],
        _                           => null,
      };

  // Áp warm ColorFilter (chỉ cho lớp hành chính — CartoDB)
  bool get useWarmFilter => this == MapBaseLayer.administrative;

  // Nền tối — boundary & toolbar cần điều chỉnh màu
  bool get isDark =>
      this == MapBaseLayer.satellite || this == MapBaseLayer.hybrid;

  // Màu preview card trong bảng chọn
  Color get previewBg => switch (this) {
        MapBaseLayer.administrative => const Color(0xFFDDD8C8),
        MapBaseLayer.terrain        => const Color(0xFFB8D4A8),
        MapBaseLayer.satellite      => const Color(0xFF1A3520),
        MapBaseLayer.hybrid         => const Color(0xFF1E3A28),
      };

  Color get previewFg =>
      isDark ? Colors.white : const Color(0xFF1A2636);
}

// ─── POI overlay categories ───────────────────────────────────────────────────

enum PoiCategory {
  school,
  hospital,
  restaurant,
  supermarket,
  hotel,
  park,
  atm,
  pharmacy,
}

extension PoiCategoryX on PoiCategory {
  String get label => switch (this) {
        PoiCategory.school      => 'Trường học',
        PoiCategory.hospital    => 'Bệnh viện',
        PoiCategory.restaurant  => 'Nhà hàng',
        PoiCategory.supermarket => 'Siêu thị',
        PoiCategory.hotel       => 'Khách sạn',
        PoiCategory.park        => 'Công viên',
        PoiCategory.atm         => 'ATM',
        PoiCategory.pharmacy    => 'Nhà thuốc',
      };

  IconData get icon => switch (this) {
        PoiCategory.school      => Icons.school_rounded,
        PoiCategory.hospital    => Icons.local_hospital_rounded,
        PoiCategory.restaurant  => Icons.restaurant_rounded,
        PoiCategory.supermarket => Icons.shopping_cart_rounded,
        PoiCategory.hotel       => Icons.hotel_rounded,
        PoiCategory.park        => Icons.park_rounded,
        PoiCategory.atm         => Icons.atm_rounded,
        PoiCategory.pharmacy    => Icons.local_pharmacy_rounded,
      };

  Color get color => switch (this) {
        PoiCategory.school      => const Color(0xFF2563EB),
        PoiCategory.hospital    => const Color(0xFFDC2626),
        PoiCategory.restaurant  => const Color(0xFFD97706),
        PoiCategory.supermarket => const Color(0xFF7C3AED),
        PoiCategory.hotel       => const Color(0xFF0891B2),
        PoiCategory.park        => const Color(0xFF16A34A),
        PoiCategory.atm         => const Color(0xFF0D9488),
        PoiCategory.pharmacy    => const Color(0xFFDB2777),
      };

  // Overpass query key/value
  String get overpassKey => this == PoiCategory.park ? 'leisure' : 'amenity';

  String get overpassValue => switch (this) {
        PoiCategory.school      => 'school',
        PoiCategory.hospital    => 'hospital',
        PoiCategory.restaurant  => 'restaurant',
        PoiCategory.supermarket => 'supermarket',
        PoiCategory.hotel       => 'hotel',
        PoiCategory.park        => 'park',
        PoiCategory.atm         => 'atm',
        PoiCategory.pharmacy    => 'pharmacy',
      };
}

// ─── POI point ────────────────────────────────────────────────────────────────

class PoiPoint {
  final double lat;
  final double lng;
  final String name;
  const PoiPoint({required this.lat, required this.lng, required this.name});
}
