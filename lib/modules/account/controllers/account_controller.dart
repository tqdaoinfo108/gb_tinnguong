import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import '../../../core/network/dio_client.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

class AccountController extends GetxController {
  final _client = DioClient();

  final user            = Rxn<UserModel>();
  final isLoading       = false.obs;
  final notifEnabled    = true.obs;
  final mapLayer        = 'Hành chính'.obs;
  final themeMode       = 'Tự động'.obs;
  final lastSyncLabel   = 'Đang cập nhật...'.obs;

  @override
  void onInit() {
    super.onInit();
    _boot();
  }

  // ── Khởi động: load nhanh từ storage, sau đó refresh từ API ──────────────
  Future<void> _boot() async {
    await _loadFromStorage();   // hiện ngay dữ liệu đã lưu
    await _fetchProfile();      // cập nhật fresh từ server
    _setLastSync();
  }

  // ── Đọc JSON đã lưu khi đăng nhập ────────────────────────────────────────
  Future<void> _loadFromStorage() async {
    try {
      final raw = await _client.getUserJson();
      if (raw == null || raw.isEmpty) return;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      user.value = UserModel.fromJson(map);
      log('AccountController: loaded user from storage → ${user.value?.displayName}');
    } catch (e) {
      log('AccountController._loadFromStorage error: $e');
    }
  }

  // ── Gọi API lấy thông tin profile mới nhất ───────────────────────────────
  Future<void> _fetchProfile() async {
    try {
      final res = await _client.dio.get('/api/user/get-info');
      final data = res.data;
      if (data == null) return;

      final map = data is Map<String, dynamic> ? data : <String, dynamic>{};
      if (map.isEmpty) return;

      // Merge với tokenID hiện có (API profile thường không trả TokenID lại)
      final existing = user.value;
      final merged = {
        if (existing != null) ...existing.toJson(),
        ...map,
      };

      final fresh = UserModel.fromJson(merged);
      user.value = fresh;

      // Cập nhật lại storage để lần sau load nhanh hơn
      await _client.saveUserJson(jsonEncode(merged));
      log('AccountController: refreshed from API → ${fresh.displayName}');
    } catch (e) {
      // Không bắt buộc — nếu API lỗi vẫn dùng data từ storage
      log('AccountController._fetchProfile skipped: $e');
    }
  }

  void _setLastSync() {
    final now = DateTime.now();
    final h   = now.hour.toString().padLeft(2, '0');
    final m   = now.minute.toString().padLeft(2, '0');
    lastSyncLabel.value = 'Lần cuối: $h:$m hôm nay';
  }

  Future<void> syncNow() async {
    isLoading.value = true;
    await _fetchProfile();
    _setLastSync();
    isLoading.value = false;
  }

  // ── Display helpers ───────────────────────────────────────────────────────

  String get initials {
    final name = user.value?.fullName ?? user.value?.userName ?? '';
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  String get displayName =>
      user.value?.fullName?.isNotEmpty == true
          ? user.value!.fullName!
          : (user.value?.userName ?? 'Người dùng');

  /// Chức vụ: PositionName → GroupName → fallback
  String get displayRole =>
      user.value?.positionName?.isNotEmpty == true
          ? user.value!.positionName!
          : (user.value?.groupName?.isNotEmpty == true
              ? user.value!.groupName!
              : 'Chưa xác định');

  /// Đơn vị công tác
  String get displayUnit => user.value?.unitName ?? '';

  String get displayEmail => user.value?.email ?? '';
  String get displayPhone => user.value?.phone  ?? '';
  String get staffCode    => user.value?.staffCode ?? '';

  Future<void> logout() async {
    await _client.clearAuth();
    Get.offAllNamed(AppRoutes.login);
  }
}

// ── Extension tiện ích ────────────────────────────────────────────────────────
extension UserModelDisplay on UserModel {
  String get displayName =>
      fullName?.isNotEmpty == true ? fullName! : userName;
}
