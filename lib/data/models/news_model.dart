class NewsModel {
  final int newsID;
  final String title;
  final String? description;
  final String? imagePath;
  final DateTime? datePublish;
  final int? statusID;
  final String? statusName;

  const NewsModel({
    required this.newsID,
    required this.title,
    this.description,
    this.imagePath,
    this.datePublish,
    this.statusID,
    this.statusName,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        newsID: (json['NewsID'] as num?)?.toInt() ?? 0,
        title: json['Title'] as String? ?? '',
        description: json['Description'] as String?,
        imagePath: json['ImagePath'] as String?,
        datePublish: json['DatePublish'] != null ? DateTime.tryParse(json['DatePublish'].toString()) : null,
        statusID: (json['StatusID'] as num?)?.toInt(),
        statusName: json['StatusName'] as String?,
      );
}
