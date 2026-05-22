class UserModel {
  final String   tokenID;
  final int      userID;
  final String   userName;
  final String?  fullName;
  final String?  email;
  final String?  phone;
  final String?  imagePath;
  final int?     userTypeID;
  final String?  groupName;
  final String?  unitName;
  final String?  positionName;
  final String?  staffCode;
  // Thêm từ update-user
  final String?  address;
  final int?     genderID;    // 1=Nam 2=Nữ 0/null=Khác
  final int?     statusID;
  final DateTime? birthday;
  final String?  relationship;
  /// Đơn vị công tác / phường-xã nơi làm việc (từ profile API field WorkUnit)
  final String?  workUnit;

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
    this.address,
    this.genderID,
    this.statusID,
    this.birthday,
    this.relationship,
    this.workUnit,
  });

  static T? _pick<T>(Map<String, dynamic> j, List<String> keys) {
    for (final k in keys) {
      if (j.containsKey(k) && j[k] != null) return j[k] as T?;
    }
    return null;
  }

  static DateTime? _pickDate(Map<String, dynamic> j, List<String> keys) {
    final raw = _pick<String>(j, keys);
    if (raw == null) return null;
    try { return DateTime.parse(raw); } catch (_) { return null; }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        tokenID:  _pick<String>(json, ['TokenID', 'tokenId', 'token']) ?? '',
        userID:   (_pick<num>(json, ['UserID', 'UserId', 'userId', 'id']))
                      ?.toInt() ?? 0,
        userName: _pick<String>(json, ['UserName', 'userName', 'username']) ?? '',
        fullName: _pick<String>(json,
            ['FullName', 'fullName', 'HoTen', 'Name', 'name']),
        email: _pick<String>(json,
            ['Email', 'email', 'EmailAddress', 'emailAddress']),
        phone: _pick<String>(json,
            ['Phone', 'phone', 'PhoneNumber', 'phoneNumber',
             'DienThoai', 'SoDienThoai']),
        imagePath: _pick<String>(json,
            ['ImagePath', 'imagePath', 'Avatar', 'avatar',
             'AvatarUrl', 'avatarUrl']),
        userTypeID: (_pick<num>(json,
            ['UserTypeID', 'userTypeId', 'UserType']))?.toInt(),
        groupName: _pick<String>(json,
            ['GroupName', 'groupName', 'RoleName', 'roleName', 'Role', 'role']),
        unitName: _pick<String>(json,
            ['UnitName', 'unitName', 'DonVi', 'OfficeName', 'officeName',
             'Department', 'department', 'OrganizationName', 'organizationName']),
        positionName: _pick<String>(json,
            ['PositionName', 'positionName', 'ChucVu', 'JobTitle',
             'jobTitle', 'Position', 'position', 'Title', 'title']),
        staffCode: _pick<String>(json,
            ['StaffCode', 'staffCode', 'MaCanBo', 'EmployeeCode',
             'employeeCode', 'Code', 'code']),
        address: _pick<String>(json,
            ['Address', 'address', 'DiaChi']),
        genderID: (_pick<num>(json,
            ['GenderID', 'genderId', 'Gender', 'gender']))?.toInt(),
        statusID: (_pick<num>(json,
            ['StatusID', 'statusId', 'Status', 'status']))?.toInt(),
        birthday: _pickDate(json,
            ['Birthday', 'birthday', 'NgaySinh', 'DateOfBirth', 'dateOfBirth']),
        relationship: _pick<String>(json,
            ['RelationShip', 'relationship', 'Relationship']),
        workUnit: _pick<String>(json,
            ['WorkUnit', 'workUnit', 'WorkUnitName', 'workUnitName']),
      );

  Map<String, dynamic> toJson() => {
        'TokenID':   tokenID,
        'UserID':    userID,
        'UserName':  userName,
        if (fullName     != null) 'FullName':     fullName,
        if (email        != null) 'Email':        email,
        if (phone        != null) 'Phone':        phone,
        if (imagePath    != null) 'ImagePath':    imagePath,
        if (userTypeID   != null) 'UserTypeID':   userTypeID,
        if (groupName    != null) 'GroupName':    groupName,
        if (unitName     != null) 'UnitName':     unitName,
        if (positionName != null) 'PositionName': positionName,
        if (staffCode    != null) 'StaffCode':    staffCode,
        if (address      != null) 'Address':      address,
        if (genderID     != null) 'GenderID':     genderID,
        if (statusID     != null) 'StatusID':     statusID,
        if (birthday     != null) 'Birthday':     birthday!.toIso8601String(),
        if (relationship != null) 'RelationShip': relationship,
        if (workUnit     != null) 'WorkUnit':     workUnit,
      };

  // copyWith để update từng field
  UserModel copyWith({
    String?  fullName,
    String?  email,
    String?  phone,
    String?  imagePath,
    String?  address,
    int?     genderID,
    DateTime? birthday,
    String?  relationship,
  }) => UserModel(
        tokenID:      tokenID,
        userID:       userID,
        userName:     userName,
        fullName:     fullName      ?? this.fullName,
        email:        email         ?? this.email,
        phone:        phone         ?? this.phone,
        imagePath:    imagePath     ?? this.imagePath,
        userTypeID:   userTypeID,
        groupName:    groupName,
        unitName:     unitName,
        positionName: positionName,
        staffCode:    staffCode,
        address:      address       ?? this.address,
        genderID:     genderID      ?? this.genderID,
        statusID:     statusID,
        birthday:     birthday      ?? this.birthday,
        relationship: relationship  ?? this.relationship,
        workUnit:     workUnit,      // không editable — giữ nguyên từ API
      );

  // display helpers
  String get displayName =>
      fullName?.isNotEmpty == true ? fullName! : userName;
  String get genderLabel => switch (genderID) {
        1 => 'Nam', 2 => 'Nữ', _ => 'Khác'
      };
}
