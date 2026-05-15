class ClassDataModel {
  final int classDataID;
  final String classDataName;
  final String? description;
  final bool? isActivity;

  const ClassDataModel({
    required this.classDataID,
    required this.classDataName,
    this.description,
    this.isActivity,
  });

  factory ClassDataModel.fromJson(Map<String, dynamic> json) => ClassDataModel(
        classDataID: (json['ClassDataID'] as num?)?.toInt() ?? 0,
        classDataName: json['ClassDataName'] as String? ?? '',
        description: json['Description'] as String?,
        isActivity: json['IsActivity'] as bool?,
      );
}
