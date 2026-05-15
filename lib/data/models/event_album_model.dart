class EventAlbumModel {
  final int eventAlbumID;
  final String? albumName;
  final String? imagePath;
  final int? eventID;
  final int? statusID;
  final String? statusName;
  final String? description;

  const EventAlbumModel({
    required this.eventAlbumID,
    this.albumName,
    this.imagePath,
    this.eventID,
    this.statusID,
    this.statusName,
    this.description,
  });

  factory EventAlbumModel.fromJson(Map<String, dynamic> json) =>
      EventAlbumModel(
        eventAlbumID: (json['EventAlbumID'] as num?)?.toInt() ?? 0,
        albumName: json['AlbumName'] as String?,
        imagePath: json['ImagePath'] as String?,
        eventID: (json['EventID'] as num?)?.toInt(),
        statusID: (json['StatusID'] as num?)?.toInt(),
        statusName: json['StatusName'] as String?,
        description: json['Description'] as String?,
      );
}

class AlbumImageModel {
  final int albumImageID;
  final String? imagePath;
  final String? description;
  final int? eventAlbumID;
  final int? statusID;

  const AlbumImageModel({
    required this.albumImageID,
    this.imagePath,
    this.description,
    this.eventAlbumID,
    this.statusID,
  });

  factory AlbumImageModel.fromJson(Map<String, dynamic> json) =>
      AlbumImageModel(
        albumImageID: (json['AlbumImageID'] as num?)?.toInt() ?? 0,
        imagePath: json['ImagePath'] as String?,
        description: json['Description'] as String?,
        eventAlbumID: (json['EventAlbumID'] as num?)?.toInt(),
        statusID: (json['StatusID'] as num?)?.toInt(),
      );
}
