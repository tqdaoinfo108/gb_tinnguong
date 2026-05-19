class UserModel {
  final String  tokenID;
  final int     userID;
  final String  userName;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? imagePath;
  final int?    userTypeID;
  // Tên nhóm / vai trò
  final String? groupName;
  // Tên đơn vị (UBND Phường 5, Sở Nội vụ…)
  final String? unitName;
  // Chức vụ / chức danh (Chuyên viên, Trưởng phòng…)
  final String? positionName;
  // Mã cán bộ
  final String? staffCode;

  const UserModel({
    required this.tokenID,
    required this.userID,
    required this.userName,
    this.fullName,
    this.email,
    this.phone,
    this.imagePath,
    this.userTypeID,
    this.groupName,
    this.unitName,
    this.positionName,
    this.staffCode,
  });

  // ── Helper: thử nhiều key-name cùng lúc ──────────────────────────────────
  static T? _pick<T>(Map<String, dynamic> j, List<String> keys) {
    for (final k in keys) {
      if (j.containsKey(k) && j[k] != null) return j[k] as T?;
    }
    return null;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        tokenID: _pick<String>(json, ['TokenID', 'tokenId', 'token']) ?? '',
        userID: (_pick<num>(json, ['UserID', 'UserId', 'userId', 'id']))
                ?.toInt() ?? 0,
        userName: _pick<String>(json, ['UserName', 'userName', 'username']) ?? '',
        fullName: _pick<String>(
            json, ['FullName', 'fullName', 'HoTen', 'Name', 'name']),
        email: _pick<String>(
            json, ['Email', 'email', 'EmailAddress', 'emailAddress']),
        phone: _pick<String>(
            json, ['PhoneNumber', 'phoneNumber', 'Phone', 'phone',
                   'DienThoai', 'SoDienThoai']),
        imagePath: _pick<String>(
            json, ['ImagePath', 'imagePath', 'Avatar', 'avatar',
                   'AvatarUrl', 'avatarUrl']),
        userTypeID: (_pick<num>(
            json, ['UserTypeID', 'userTypeId', 'UserType']))?.toInt(),
        groupName: _pick<String>(
            json, ['GroupName', 'groupName', 'RoleName', 'roleName',
                   'Role', 'role']),
        unitName: _pick<String>(
            json, ['UnitName', 'unitName', 'DonVi', 'OfficeName',
                   'officeName', 'Department', 'department',
                   'OrganizationName', 'organizationName']),
        positionName: _pick<String>(
            json, ['PositionName', 'positionName', 'ChucVu', 'JobTitle',
                   'jobTitle', 'Position', 'position', 'Title', 'title']),
        staffCode: _pick<String>(
            json, ['StaffCode', 'staffCode', 'MaCanBo', 'EmployeeCode',
                   'employeeCode', 'Code', 'code']),
      );

  Map<String, dynamic> toJson() => {
        'TokenID':      tokenID,
        'UserID':       userID,
        'UserName':     userName,
        if (fullName     != null) 'FullName':     fullName,
        if (email        != null) 'Email':        email,
        if (phone        != null) 'PhoneNumber':  phone,
        if (imagePath    != null) 'ImagePath':    imagePath,
        if (userTypeID   != null) 'UserTypeID':   userTypeID,
        if (groupName    != null) 'GroupName':    groupName,
        if (unitName     != null) 'UnitName':     unitName,
        if (positionName != null) 'PositionName': positionName,
        if (staffCode    != null) 'StaffCode':    staffCode,
      };
}
