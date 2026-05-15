/// Model cho một điểm đánh dấu trên bản đồ số.
class MapMarker {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final MapMarkerType type;
  final MapMarkerStatus status;
  final String? address;
  final String? phone;
  final DateTime? lastUpdated;

  const MapMarker({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.status = MapMarkerStatus.active,
    this.address,
    this.phone,
    this.lastUpdated,
  });
}

enum MapMarkerType {
  administrative, // UBND, trụ sở
  infrastructure, // Công trình hạ tầng
  residential,    // Khu dân cư
  greenSpace,     // Công viên, cây xanh
  medical,        // Y tế
  education,      // Giáo dục
  construction,   // Công trường
}

enum MapMarkerStatus {
  active,
  inactive,
  underConstruction,
  planned,
}

/// Model cho một layer (lớp bản đồ).
class MapLayer {
  final String id;
  final String name;
  final String description;
  final MapLayerType type;
  bool isVisible;
  final int markerCount;

  MapLayer({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.isVisible = true,
    this.markerCount = 0,
  });
}

enum MapLayerType {
  administrative,
  infrastructure,
  residential,
  environment,
  utility,
}

/// Model cho thống kê bản đồ.
class MapStatistic {
  final String label;
  final String value;
  final String unit;
  final MapStatisticTrend trend;
  final String trendText;

  const MapStatistic({
    required this.label,
    required this.value,
    this.unit = '',
    this.trend = MapStatisticTrend.stable,
    this.trendText = '',
  });
}

enum MapStatisticTrend { up, down, stable }

/// Model cho một khu vực hành chính.
class AdminZone {
  final String id;
  final String name;
  final String type; // Phường, Xã, Thị trấn
  final int population;
  final double area; // km²
  final int projectCount;

  const AdminZone({
    required this.id,
    required this.name,
    required this.type,
    required this.population,
    required this.area,
    this.projectCount = 0,
  });
}

/// Model cho bộ lọc bản đồ.
class MapFilter {
  final String id;
  final String label;
  final MapMarkerType? markerType;
  bool isSelected;

  MapFilter({
    required this.id,
    required this.label,
    this.markerType,
    this.isSelected = false,
  });
}
