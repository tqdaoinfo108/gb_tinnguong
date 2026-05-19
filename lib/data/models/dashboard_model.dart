class DashboardModel {
  final int totalOffice;
  final int totalUser;
  final int totalEvent;
  final int totalEventPermit;
  final int totalArea;
  final int totalBeliever;
  final List<ReligionBreakdown> religionData;
  final List<StatusBreakdown>   statusData;
  final List<ProfileBreakdown>  profileData;

  const DashboardModel({
    this.totalOffice       = 0,
    this.totalUser         = 0,
    this.totalEvent        = 0,
    this.totalEventPermit  = 0,
    this.totalArea         = 0,
    this.totalBeliever     = 0,
    this.religionData      = const [],
    this.statusData        = const [],
    this.profileData       = const [],
  });

  factory DashboardModel.fromJson(Map<String, dynamic> j) {
    int getInt(String k) => (j[k] as num?)?.toInt() ?? 0;

    List<T> getList<T>(String k, T Function(Map<String, dynamic>) fn) {
      final raw = j[k];
      if (raw is! List) return [];
      return raw.map((e) => fn(e as Map<String, dynamic>)).toList();
    }

    return DashboardModel(
      totalOffice:      getInt('TotalOffice'),
      totalUser:        getInt('TotalUser'),
      totalEvent:       getInt('TotalEvent'),
      totalEventPermit: getInt('TotalEventPermit'),
      totalArea:        getInt('TotalArea') > 0
                            ? getInt('TotalArea')
                            : getInt('TotalAcreage'),
      totalBeliever:    getInt('TotalBeliever'),
      religionData: getList('ReligionData', ReligionBreakdown.fromJson),
      statusData:   getList('StatusData',   StatusBreakdown.fromJson),
      profileData:  getList('ProfileData',  ProfileBreakdown.fromJson),
    );
  }

  static const empty = DashboardModel();
}

// ── Sub-models ────────────────────────────────────────────────────────────────

class ReligionBreakdown {
  final String religionName;
  final int    total;
  const ReligionBreakdown({required this.religionName, required this.total});

  factory ReligionBreakdown.fromJson(Map<String, dynamic> j) => ReligionBreakdown(
    religionName: j['ReligionName'] as String? ?? '',
    total:        (j['Total'] as num?)?.toInt() ?? 0,
  );
}

class StatusBreakdown {
  final String statusName;
  final int?   statusID;
  final int    total;
  const StatusBreakdown({required this.statusName, this.statusID, required this.total});

  factory StatusBreakdown.fromJson(Map<String, dynamic> j) => StatusBreakdown(
    statusName: j['StatusName'] as String? ?? '',
    statusID:   (j['StatusID'] as num?)?.toInt(),
    total:      (j['Total'] as num?)?.toInt() ?? 0,
  );
}

class ProfileBreakdown {
  final String label;
  final int    total;
  const ProfileBreakdown({required this.label, required this.total});

  factory ProfileBreakdown.fromJson(Map<String, dynamic> j) => ProfileBreakdown(
    label: j['StatusName'] as String? ?? j['Label'] as String? ?? '',
    total: (j['Total'] as num?)?.toInt() ?? 0,
  );
}
