import 'dart:developer';
import '../../core/network/dio_client.dart';
import '../models/user_model.dart';

class UserService {
  final _dio = DioClient().dio;

  // ── GET /api/user/profile ─────────────────────────────────────────────────
  Future<UserModel?> getProfile() async {
    try {
      final res = await _dio.get('/api/user/profile');
      final data = res.data;
      if (data == null) return null;
      final map = data is Map<String, dynamic> ? data : <String, dynamic>{};
      return UserModel.fromJson(map);
    } catch (e) {
      log('UserService.getProfile error: $e');
      return null;
    }
  }

  // ── POST /api/user/update-user ────────────────────────────────────────────
  Future<bool> updateUser(UserModel u) async {
    try {
      await _dio.post('/api/user/update-user', data: {
        'UserID':       u.userID,
        'UserTypeID':   u.userTypeID ?? 0,
        'UserName':     u.userName,
        'FullName':     u.fullName   ?? '',
        'Email':        u.email      ?? '',
        'Phone':        u.phone      ?? '',
        'Address':      u.address    ?? '',
        'GenderID':     u.genderID   ?? 0,
        'StatusID':     u.statusID   ?? 1,
        'ImagePath':    u.imagePath  ?? '',
        'Birthday':     u.birthday?.toIso8601String() ?? '',
        'RelationShip': u.relationship ?? '',
      });
      return true;
    } catch (e) {
      log('UserService.updateUser error: $e');
      return false;
    }
  }

  // ── POST /api/user/update-avarta ──────────────────────────────────────────
  Future<bool> updateAvatar(String imagePath) async {
    try {
      await _dio.post('/api/user/update-avarta', data: {
        'ImagePath': imagePath,
      });
      return true;
    } catch (e) {
      log('UserService.updateAvatar error: $e');
      return false;
    }
  }

  // ── POST /api/user/change-password ────────────────────────────────────────
  Future<({bool ok, String message})> changePassword({
    required String userName,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post('/api/user/change-password', data: {
        'PassWordOld': oldPassword,
        'PassWordNew': newPassword,
        'UserName':    userName,
      });
      return (ok: true, message: 'Đổi mật khẩu thành công');
    } catch (e) {
      log('UserService.changePassword error: $e');
      final msg = e.toString().contains('Message')
          ? e.toString()
          : 'Mật khẩu hiện tại không đúng';
      return (ok: false, message: msg);
    }
  }
}
