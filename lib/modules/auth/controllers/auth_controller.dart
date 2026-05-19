import 'dart:convert' show base64Encode, utf8, jsonEncode;
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/values/app_colors.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final _dioClient = DioClient();

  final isLoading       = false.obs;
  final passwordVisible = false.obs;
  final rememberMe      = true.obs;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final currentUser = Rxn<UserModel>();

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => passwordVisible.toggle();

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _snack('Lỗi', 'Vui lòng nhập tài khoản và mật khẩu', error: true);
      return;
    }

    isLoading.value = true;
    try {
      final credentials = base64Encode(utf8.encode('UserAPItinNguong:UserPassAPItinNguongTonGiao'));
      final res = await _dioClient.dio.post(
        '/api/user/login',
        data: {'UserName': username, 'PassWord': password},
        options: Options(headers: {'Authorization': 'Basic $credentials'}),
      );

      final data = res.data;
      if (data != null && data is Map<String, dynamic> && data['TokenID'] != null) {
        await _dioClient.saveToken(data['TokenID'] as String);
        await _dioClient.saveUserJson(jsonEncode(data));
        currentUser.value = UserModel.fromJson(data);
        Get.offAllNamed(AppRoutes.main);
      } else {
        _snack('Lỗi', 'Thông tin đăng nhập không hợp lệ', error: true);
      }
    } on DioException catch (e) {
      log('Login DioException: $e');
      final msg = e.response?.data?['Message'] as String? ?? e.message ?? 'Lỗi kết nối';
      _snack('Đăng nhập thất bại', msg, error: true);
    } catch (e) {
      log('Login error: $e');
      _snack('Lỗi', e.toString(), error: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _dioClient.clearAuth();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  void _snack(String title, String message, {bool error = false}) {
    Get.snackbar(
      title, message,
      backgroundColor: error ? AppColors.redBg : AppColors.emeraldBg,
      colorText: error ? AppColors.redFg : AppColors.emeraldFg,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
