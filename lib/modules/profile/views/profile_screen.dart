import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cá Nhân'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.primaryBlue,
              padding: EdgeInsets.only(bottom: 32.h),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50.r, color: AppColors.primaryBlue),
                    ),
                    SizedBox(height: 16.h),
                    Obx(() => Text(
                      controller.userName.value,
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    )),
                    SizedBox(height: 8.h),
                    Obx(() => Text(
                      controller.email.value,
                      style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                    )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tài khoản', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.h),
                  _buildMenuRow(Icons.person_outline, 'Chỉnh sửa hồ sơ'),
                  _buildMenuRow(Icons.lock_outline, 'Đổi mật khẩu'),
                  SizedBox(height: 24.h),
                  Text('Hệ thống', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.h),
                  _buildMenuRow(Icons.notifications_none, 'Cài đặt thông báo'),
                  _buildMenuRow(Icons.help_outline, 'Trợ giúp & Hỗ trợ'),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.alertRed),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      onPressed: () {
                        controller.logout();
                      },
                      child: Text('ĐĂNG XUẤT', style: TextStyle(color: AppColors.alertRed, fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuRow(IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.primaryBlueLight,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: AppColors.primaryBlue),
      ),
      title: Text(title, style: TextStyle(fontSize: 15.sp)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
