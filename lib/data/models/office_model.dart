class OfficeModel {
  final int officeID;
  final String officeName;
  final String? officeAddress;
  final String? officeDescription;
  final int? typeOfficeID;
  final String? typeOfficeName;
  final int? religionID;
  final String? religionName;
  final int? villageID;
  final String? villageName;
  final int? statusID;
  final String? statusName;
  final bool? isActivity;
  final String? codeActivity;
  final int? yearBuilt;
  final double? acreage;
  final int? totalUser;
  final int? totalBeliever;
  final bool? hasLicense;
  final double? latitude;
  final double? longitude;

  const OfficeModel({
    required this.officeID,
    required this.officeName,
    this.officeAddress,
    this.officeDescription,
    this.typeOfficeID,
    this.typeOfficeName,
    this.religionID,
    this.religionName,
    this.villageID,
    this.villageName,
    this.statusID,
    this.statusName,
    this.isActivity,
    this.codeActivity,
    this.yearBuilt,
    this.acreage,
    this.totalUser,
    this.totalBeliever,
    this.hasLicense,
    this.latitude,
    this.longitude,
  });

  factory OfficeModel.fromJson(Map<String, dynamic> json) {
    double? lat = (json['Latitude'] as num?)?.toDouble();
    double? lng = (json['Longitude'] as num?)?.toDouble();
    if ((lat == null || lng == null) && json['LocationGis'] != null) {
      final wkt = json['LocationGis']?['Geography']?['WellKnownText'] as String?;
      if (wkt != null) {
        final m = RegExp(r'POINT\s*\(\s*([\d.+\-]+)\s+([\d.+\-]+)\s*\)').firstMatch(wkt);
        if (m != null) {
          lng = double.tryParse(m.group(1)!);
          lat = double.tryParse(m.group(2)!);
        }
      }
    }
    return OfficeModel(
      officeID: (json['OfficeID'] as num?)?.toInt() ?? 0,
      officeName: json['OfficeName'] as String? ?? '',
      officeAddress: json['OfficeAddress'] as String?,
      officeDescription: json['OfficeDescription'] as String?,
      typeOfficeID: (json['TypeOfficeID'] as num?)?.toInt(),
      typeOfficeName: json['TypeOfficeName'] as String?,
      religionID: (json['ReligionID'] as num?)?.toInt(),
      religionName: json['ReligionName'] as String?,
      villageID: (json['VillageID'] as num?)?.toInt(),
      villageName: json['VillageName'] as String?,
      statusID: (json['StatusID'] as num?)?.toInt(),
      statusName: json['StatusName'] as String?,
      isActivity: json['IsActivity'] as bool?,
      codeActivity: json['CodeActivity'] as String?,
      yearBuilt: (json['YearBuilt'] as num?)?.toInt(),
      acreage: (json['Acreage'] as num?)?.toDouble(),
      totalUser: (json['TotalUser'] as num?)?.toInt(),
      totalBeliever: (json['TotalBeliever'] as num?)?.toInt(),
      hasLicense: json['HasLicense'] as bool?,
      latitude: lat,
      longitude: lng,
    );
  }
}

// ── Người lãnh đạo / trụ trì của cơ sở ──────────────────────────
class OfficeLeaderModel {
  final int officeUserID;
  final int userID;
  final String fullName;
  final String? email;
  final String? phone;
  final String? positionName;
  final String? officeName;
  final String? villageName;
  final String? statusName;
  final DateTime? dateStart;
  final DateTime? dateEnd;

  const OfficeLeaderModel({
    required this.officeUserID,
    required this.userID,
    required this.fullName,
    this.email,
    this.phone,
    this.positionName,
    this.officeName,
    this.villageName,
    this.statusName,
    this.dateStart,
    this.dateEnd,
  });

  factory OfficeLeaderModel.fromJson(Map<String, dynamic> json) =>
      OfficeLeaderModel(
        officeUserID: (json['OfficeUserID'] as num?)?.toInt() ?? 0,
        userID:       (json['UserID']       as num?)?.toInt() ?? 0,
        fullName:     json['FullName']   as String? ?? '',
        email:        json['Email']      as String?,
        phone:        json['Phone']      as String?,
        positionName: json['PositionName'] as String?,
        officeName:   json['OfficeName']   as String?,
        villageName:  json['VillageName']  as String?,
        statusName:   json['StatusName']   as String?,
        dateStart: json['DateStart'] != null
            ? DateTime.tryParse(json['DateStart'] as String)
            : null,
        dateEnd: json['DateEnd'] != null
            ? DateTime.tryParse(json['DateEnd'] as String)
            : null,
      );

  /// Chữ viết tắt 1-2 ký tự để làm avatar
  String get initials {
    if (fullName.isEmpty) return '?';
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
