/// Base Model — Tất cả model đều kế thừa class này.
/// Ép buộc implement fromJson và toJson.
abstract class BaseModel {
  const BaseModel();

  Map<String, dynamic> toJson();
}

