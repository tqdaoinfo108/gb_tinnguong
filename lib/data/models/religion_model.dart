class ReligionModel {
  final int religionID;
  final String religionName;
  final String? description;
  final bool? isActivity;

  const ReligionModel({
    required this.religionID,
    required this.religionName,
    this.description,
    this.isActivity,
  });

  factory ReligionModel.fromJson(Map<String, dynamic> json) => ReligionModel(
        religionID: (json['ReligionID'] as num?)?.toInt() ?? 0,
        religionName: json['ReligionName'] as String? ?? '',
        description: json['Description'] as String?,
        isActivity: json['IsActivity'] as bool?,
      );
}
