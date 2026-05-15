import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.tileDark,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BrandingBlock(top: top),
            Expanded(
              child: SingleChildScrollView(
                child: _FormCard(bottom: MediaQuery.of(context).padding.bottom),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandingBlock extends StatelessWidget {
  final double top;
  const _BrandingBlock({required this.top});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gold radial glow
        Positioned(
          left: -60, top: -60,
          child: Container(
            width: 320, height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColors.gold.withValues(alpha: 0.22),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 36, 28, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TIN NGƯỠNG · GIS', style: GoogleFonts.inter(
                fontSize: 11, fontWeight: FontWeight.w500,
                color: AppColors.goldSoft, letterSpacing: 0.06,
              )),
              const SizedBox(height: 20),
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.35), width: 1),
                ),
                child: const Icon(Icons.account_balance_rounded, size: 24, color: AppColors.gold),
              ),
              const SizedBox(height: 16),
              Text('Tín Ngưỡng GIS', style: GoogleFonts.inter(
                fontSize: 30, fontWeight: FontWeight.w700,
                color: AppColors.onDark, letterSpacing: -0.025, height: 1.12,
              )),
              const SizedBox(height: 6),
              Text('Phường 5 · Quận Bình Thạnh', style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onDarkMuted,
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class _FormCard extends GetView<AuthController> {
  final double bottom;
  const _FormCard({required this.bottom});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.55,
      ),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(28, 32, 28, bottom + 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Đăng nhập', style: GoogleFonts.inter(
            fontSize: 22, fontWeight: FontWeight.w700,
            color: AppColors.ink, letterSpacing: -0.015,
          )),
          const SizedBox(height: 4),
          Text('Nhập thông tin tài khoản để tiếp tục', style: GoogleFonts.inter(
            fontSize: 13, color: AppColors.inkSoft,
          )),
          const SizedBox(height: 28),

          // Username
          _FieldLabel('Tên đăng nhập'),
          const SizedBox(height: 7),
          _InputBox(
            controller: controller.usernameController,
            hint: 'Nhập tên đăng nhập',
            icon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 18),

          // Password
          _FieldLabel('Mật khẩu'),
          const SizedBox(height: 7),
          Obx(() => _InputBox(
            controller: controller.passwordController,
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscure: !controller.passwordVisible.value,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => controller.login(),
            suffix: GestureDetector(
              onTap: controller.togglePasswordVisibility,
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Icon(
                  controller.passwordVisible.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18, color: AppColors.inkSoft,
                ),
              ),
            ),
          )),

          const SizedBox(height: 32),

          // Login button
          Obx(() => _LoginButton(
            loading: controller.isLoading.value,
            onTap: controller.login,
          )),

          const SizedBox(height: 32),

          Center(child: Text(
            'v1.0.0 · Hệ thống quản lý tín ngưỡng',
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.inkFaint),
          )),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text, style: GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w600,
    color: AppColors.inkMuted, letterSpacing: 0.01,
  ));
}

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const _InputBox({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Icon(icon, size: 18, color: AppColors.inkSoft),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              style: GoogleFonts.inter(fontSize: 15, color: AppColors.ink),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.inkFaint),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              ),
            ),
          ),
          ?suffix,
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;
  const _LoginButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 52,
        decoration: BoxDecoration(
          color: loading ? AppColors.primary.withValues(alpha: 0.55) : AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: loading
              ? const SizedBox(width: 22, height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : Text('Đăng nhập', style: GoogleFonts.inter(
                  fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white,
                )),
        ),
      ),
    );
  }
}
