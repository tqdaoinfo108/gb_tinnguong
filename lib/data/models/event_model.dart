class EventModel {
  final int eventID;
  final String eventName;
  final int? typeEventID;
  final String? typeEventName;
  final int? officeID;
  final String? officeName;
  final String? religionName;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final int? personJoin;
  final bool? isActivity;
  final String? codeActivity;
  final int? statusID;
  final String? statusName;
  final bool? hasPermit;
  final String? permitNo;
  final String? villageName;
  final String? description;

  const EventModel({
    required this.eventID,
    required this.eventName,
    this.typeEventID,
    this.typeEventName,
    this.officeID,
    this.officeName,
    this.religionName,
    this.dateStart,
    this.dateEnd,
    this.personJoin,
    this.isActivity,
    this.codeActivity,
    this.statusID,
    this.statusName,
    this.hasPermit,
    this.permitNo,
    this.villageName,
    this.description,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        eventID: (json['EventID'] as num?)?.toInt() ?? 0,
        eventName: json['EventName'] as String? ?? '',
        typeEventID: (json['TypeEventID'] as num?)?.toInt(),
        typeEventName: json['TypeEventName'] as String?,
        officeID: (json['OfficeID'] as num?)?.toInt(),
        officeName: json['OfficeName'] as String?,
        religionName: json['ReligionName'] as String?,
        dateStart: json['DateStart'] != null ? DateTime.tryParse(json['DateStart'].toString()) : null,
        dateEnd: json['DateEnd'] != null ? DateTime.tryParse(json['DateEnd'].toString()) : null,
        personJoin: (json['PersonJoin'] as num?)?.toInt(),
        isActivity: json['IsActivity'] as bool?,
        codeActivity: json['CodeActivity'] as String?,
        statusID: (json['StatusID'] as num?)?.toInt(),
        statusName: json['StatusName'] as String?,
        hasPermit: json['HasPermit'] as bool?,
        permitNo: json['PermitNo'] as String?,
        villageName: json['VillageName'] as String?,
        description: json['Description'] as String?,
      );
}
