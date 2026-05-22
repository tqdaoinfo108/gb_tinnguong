class CityModel {
  final int cityID;
  final String cityName;
  final String? description;

  const CityModel({
    required this.cityID,
    required this.cityName,
    this.description,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        cityID: (json['CityID'] as num?)?.toInt() ?? 0,
        cityName: json['CityName'] as String? ?? '',
        description: json['Description'] as String?,
      );
}

class CityPointModel {
  final int cityPointID;
  final int cityID;
  final int order;
  final double? latitude;
  final double? longitude;
  final String? wellKnownText;

  const CityPointModel({
    required this.cityPointID,
    required this.cityID,
    required this.order,
    this.latitude,
    this.longitude,
    this.wellKnownText,
  });

  factory CityPointModel.fromJson(Map<String, dynamic> json) {
    double? lat;
    double? lng;

    // API trả về: LocationGis.Geography.WellKnownText = "POINT (lng lat)"
    // Thử lấy từ nested path trước, fallback top-level nếu có
    String? wkt = json['WellKnownText'] as String?;
    if (wkt == null) {
      final locationGis = json['LocationGis'];
      if (locationGis is Map<String, dynamic>) {
        final geography = locationGis['Geography'];
        if (geography is Map<String, dynamic>) {
          wkt = geography['WellKnownText'] as String?;
        }
      }
    }

    // Parse WKT: "POINT (lng lat)" — kinh độ trước, vĩ độ sau
    if (wkt != null) {
      final m = RegExp(r'POINT\s*\(\s*([\d.+\-]+)\s+([\d.+\-]+)\s*\)')
          .firstMatch(wkt);
      if (m != null) {
        lng = double.tryParse(m.group(1)!);
        lat = double.tryParse(m.group(2)!);
      }
    }

    // Fallback: field tường minh
    lat ??= (json['Latitude'] as num?)?.toDouble();
    lng ??= (json['Longitude'] as num?)?.toDouble();

    return CityPointModel(
      cityPointID: (json['CityPointID'] as num?)?.toInt() ?? 0,
      cityID: (json['CityID'] as num?)?.toInt() ?? 0,
      order: (json['Order'] as num?)?.toInt() ?? 0,
      latitude: lat,
      longitude: lng,
      wellKnownText: wkt,
    );
  }
}
