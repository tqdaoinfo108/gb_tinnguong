// Simple ID + Name pairs used for dropdown lists.

class TypeEventModel {
  final int typeEventID;
  final String typeEventName;
  const TypeEventModel({required this.typeEventID, required this.typeEventName});
  factory TypeEventModel.fromJson(Map<String, dynamic> j) => TypeEventModel(
        typeEventID: (j['TypeEventID'] as num?)?.toInt() ?? 0,
        typeEventName: j['TypeEventName'] as String? ?? '',
      );
}

class VillageModel {
  final int villageID;
  final String villageName;
  const VillageModel({required this.villageID, required this.villageName});
  factory VillageModel.fromJson(Map<String, dynamic> j) => VillageModel(
        villageID: (j['VillageID'] as num?)?.toInt() ?? 0,
        villageName: j['VillageName'] as String? ?? '',
      );
}
