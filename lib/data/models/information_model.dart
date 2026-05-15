class InformationModel {
  final int informationID;
  final String title;
  final int? levelID;
  final String? levelName;
  final String? shortDescription;
  final String? description;
  final DateTime? dateCreate;
  final bool isRead;
  final String? senderName;
  final String? senderRole;

  const InformationModel({
    required this.informationID,
    required this.title,
    this.levelID,
    this.levelName,
    this.shortDescription,
    this.description,
    this.dateCreate,
    this.isRead = false,
    this.senderName,
    this.senderRole,
  });

  factory InformationModel.fromJson(Map<String, dynamic> json) => InformationModel(
        informationID: (json['InformationID'] as num?)?.toInt() ?? 0,
        title: json['Title'] as String? ?? '',
        levelID: (json['LevelID'] as num?)?.toInt(),
        levelName: json['LevelName'] as String?,
        shortDescription: json['ShortDescription'] as String?,
        description: json['Description'] as String?,
        dateCreate: json['DateCreate'] != null ? DateTime.tryParse(json['DateCreate'].toString()) : null,
        isRead: json['IsRead'] as bool? ?? false,
        senderName: json['SenderName'] as String?,
        senderRole: json['SenderRole'] as String?,
      );
}
