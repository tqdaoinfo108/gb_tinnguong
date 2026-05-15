class UserModel {
  final String tokenID;
  final int userID;
  final String userName;
  final String? fullName;
  final String? email;
  final String? imagePath;
  final int? userTypeID;
  final String? groupName;

  const UserModel({
    required this.tokenID,
    required this.userID,
    required this.userName,
    this.fullName,
    this.email,
    this.imagePath,
    this.userTypeID,
    this.groupName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        tokenID: json['TokenID'] as String? ?? '',
        userID: (json['UserID'] as num?)?.toInt() ?? 0,
        userName: json['UserName'] as String? ?? '',
        fullName: json['FullName'] as String?,
        email: json['Email'] as String?,
        imagePath: json['ImagePath'] as String?,
        userTypeID: (json['UserTypeID'] as num?)?.toInt(),
        groupName: json['GroupName'] as String?,
      );
}
