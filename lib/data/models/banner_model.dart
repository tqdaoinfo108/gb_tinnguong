class BannerModel {
  final int bannerID;
  final String? bannerName;
  final String? imagePath;
  final String? description;
  final int? typeBannerID;
  final int? officeID;
  final int? statusID;

  const BannerModel({
    required this.bannerID,
    this.bannerName,
    this.imagePath,
    this.description,
    this.typeBannerID,
    this.officeID,
    this.statusID,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        bannerID: (json['BannerID'] as num?)?.toInt() ?? 0,
        bannerName: json['BannerName'] as String?,
        imagePath: json['ImagePath'] as String?,
        description: json['Description'] as String?,
        typeBannerID: (json['TypeBannerID'] as num?)?.toInt(),
        officeID: (json['OfficeID'] as num?)?.toInt(),
        statusID: (json['StatusID'] as num?)?.toInt(),
      );

  /// Check if this banner is an image file
  bool get isImage {
    final path = (imagePath ?? '').toLowerCase();
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.gif') ||
        path.endsWith('.webp') ||
        path.endsWith('.bmp');
  }

  /// Check if this banner is a document file
  bool get isDocument => !isImage && imagePath != null && imagePath!.isNotEmpty;

  /// Get file extension
  String get fileExtension {
    final path = imagePath ?? '';
    final dot = path.lastIndexOf('.');
    if (dot == -1) return '';
    return path.substring(dot + 1).toUpperCase();
  }
}
