import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/values/app_colors.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/app_routes.dart';

class AccountController extends GetxController {
  final _client  = DioClient();
  final _service = UserService();

  final user          = Rxn<UserModel>();
  final isLoading     = false.obs;
  final isSaving      = false.obs;
  final notifEnabled  = true.obs;
  final mapLayer      = 'Hành chính'.obs;
  final themeMode     = 'Tự động'.obs;
  final lastSyncLabel = 'Đang cập nhật...'.obs;

  @override
  void onInit() {
    super.onInit();
    _boot();
  }

  Future<void> _boot() async {
    await _loadFromStorage();
    await _fetchProfile();
    _setLastSync();
  }

  Future<void> _loadFromStorage() async {
    try {
      final raw = await _client.getUserJson();
      if (raw == null || raw.isEmpty) return;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      user.value = UserModel.fromJson(map);
    } catch (e) {
      log('AccountController._loadFromStorage error: $e');
    }
  }

  Future<void> _fetchProfile() async {
    try {
      final fresh = await _service.getProfile();
      if (fresh == null) return;
      // Merge: giữ tokenID từ storage vì /profile thường không trả lại
      final merged = UserModel.fromJson({
        if (user.value != null) ...user.value!.toJson(),
        ...fresh.toJson(),
      });
      user.value = merged;
      await _client.saveUserJson(jsonEncode(merged.toJson()));
    } catch (e) {
      log('AccountController._fetchProfile error: $e');
    }
  }

  void _setLastSync() {
    final now = DateTime.now();
    lastSyncLabel.value =
        'Lần cuối: ${now.hour.toString().padLeft(2,'0')}:'
        '${now.minute.toString().padLeft(2,'0')} hôm nay';
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

  String get displayName    => user.value?.displayName   ?? 'Người dùng';
  String get displayRole    => user.value?.positionName?.isNotEmpty == true
                                  ? user.value!.positionName!
                                  : (user.value?.groupName ?? 'Chưa xác định');
  String get displayUnit    => user.value?.unitName  ?? '';
  String get displayEmail   => user.value?.email     ?? '';
  String get displayPhone   => user.value?.phone     ?? '';
  String get staffCode      => user.value?.staffCode ?? '';

  /// Đơn vị công tác (phường/xã) từ WorkUnit — null nếu chưa có.
  String? get displayWorkUnit {
    final wu = user.value?.workUnit?.trim();
    return (wu != null && wu.isNotEmpty) ? wu : null;
  }

  // ── Update profile ────────────────────────────────────────────────────────

  Future<bool> saveProfile(UserModel updated) async {
    isSaving.value = true;
    try {
      final ok = await _service.updateUser(updated);
      if (ok) {
        user.value = updated;
        await _client.saveUserJson(jsonEncode(updated.toJson()));
        // Snack KHÔNG gọi ở đây — gọi sau khi screen đã pop,
        // tránh snackbar mất overlay context khi Get.back() chạy ngay sau.
      } else {
        _snack('Lỗi', 'Không thể lưu thay đổi', error: true);
      }
      return ok;
    } catch (e) {
      log('AccountController.saveProfile error: $e');
      _snack('Lỗi', 'Có lỗi xảy ra, vui lòng thử lại', error: true);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Hiển thị thông báo thành công (public — dùng sau khi screen đã pop).
  void showSaveSuccess() =>
      _snack('Thành công', 'Đã cập nhật thông tin cá nhân');

  // ── Avatar ────────────────────────────────────────────────────────────────

  Future<void> pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxWidth: 512,
    );
    if (picked == null) return;

    isSaving.value = true;
    try {
      final bytes    = await picked.readAsBytes();
      final b64      = _bytesToBase64DataUrl(bytes, picked.name);
      final ok       = await _service.updateAvatar(b64);
      if (ok) {
        user.value = user.value?.copyWith(imagePath: b64);
        await _client.saveUserJson(jsonEncode(user.value?.toJson() ?? {}));
        _snack('Thành công', 'Đã cập nhật ảnh đại diện');
      } else {
        _snack('Lỗi', 'Không thể tải ảnh lên', error: true);
      }
    } catch (e) {
      log('pickAndUploadAvatar error: $e');
      _snack('Lỗi', 'Có lỗi xảy ra', error: true);
    } finally {
      isSaving.value = false;
    }
  }

  String _bytesToBase64DataUrl(Uint8List bytes, String name) {
    final ext = name.toLowerCase().endsWith('.png') ? 'png' : 'jpeg';
    return 'data:image/$ext;base64,${base64Encode(bytes)}';
  }

  // ── Change password ───────────────────────────────────────────────────────

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      _snack('Lỗi', 'Mật khẩu xác nhận không khớp', error: true);
      return false;
    }
    if (newPassword.length < 6) {
      _snack('Lỗi', 'Mật khẩu mới phải có ít nhất 6 ký tự', error: true);
      return false;
    }
    isSaving.value = true;
    try {
      final result = await _service.changePassword(
        userName:    user.value?.userName ?? '',
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      if (result.ok) {
        _snack('Thành công', result.message);
      } else {
        _snack('Thất bại', result.message, error: true);
      }
      return result.ok;
    } finally {
      isSaving.value = false;
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await _client.clearAuth();
    Get.offAllNamed(AppRoutes.login);
  }

  // ── Snackbar ──────────────────────────────────────────────────────────────

  void _snack(String title, String message, {bool error = false}) {
    Get.snackbar(
      title, message,
      backgroundColor: error ? AppColors.redBg : AppColors.emeraldBg,
      colorText:       error ? AppColors.redFg : AppColors.emeraldFg,
      snackPosition:   SnackPosition.BOTTOM,
      margin:          const EdgeInsets.all(16),
      borderRadius:    12,
      duration:        const Duration(seconds: 3),
    );
  }
}
