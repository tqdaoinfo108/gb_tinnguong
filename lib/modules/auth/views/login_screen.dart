import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final top    = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.parchment,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(28, top + 24, 28, bottom + 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Logo mark ──────────────────────────────────────
              Image.asset(
                'assets/app-icon-mark-1024.png',
                width: 48, height: 48,
                alignment: Alignment.centerLeft,
              ),

              const SizedBox(height: 32),

              // ── Heading ────────────────────────────────────────
              Text(
                'Đăng nhập',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sử dụng tài khoản công vụ do Phòng Nội vụ\nPhường 5 cấp.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.inkSoft,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 36),

              // ── Username ───────────────────────────────────────
              const _FieldLabel('Mã cán bộ hoặc email'),
              const SizedBox(height: 8),
              _UsernameField(ctrl: controller),

              const SizedBox(height: 20),

              // ── Password ───────────────────────────────────────
              const _FieldLabel('Mật khẩu'),
              const SizedBox(height: 8),
              _PasswordField(ctrl: controller),

              const SizedBox(height: 16),

              // ── Remember me + Forgot ───────────────────────────
              Row(
                children: [
                  Obx(() => GestureDetector(
                    onTap: () => controller.rememberMe.toggle(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 20, height: 20,
                          decoration: BoxDecoration(
                            color: controller.rememberMe.value
                                ? AppColors.primary
                                : AppColors.canvas,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: controller.rememberMe.value
                                  ? AppColors.primary
                                  : AppColors.hairlineStrong,
                              width: 1.5,
                            ),
                          ),
                          child: controller.rememberMe.value
                              ? const Icon(Icons.check_rounded,
                                  size: 13, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ghi nhớ thiết bị',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.inkMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )),

                  const Spacer(),

                  Text(
                    'Quên mật khẩu?',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Login button ───────────────────────────────────
              Obx(() => _LoginButton(
                loading: controller.isLoading.value,
                onTap: controller.login,
              )),

              const SizedBox(height: 40),

              // ── Footer ─────────────────────────────────────────
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.inkSoft),
                    children: [
                      const TextSpan(text: 'Chưa có tài khoản? Liên hệ '),
                      TextSpan(
                        text: 'Phòng Nội vụ Phường 5',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  'Hỗ trợ  ·  Điều khoản  ·  Quyền riêng tư',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.inkFaint,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Tín Ngưỡng  ·  v 1.0.0  ·  build 2026.05',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.primary.withValues(alpha: 0.45),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Field label (ALL CAPS, primary blue) ──────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
      letterSpacing: 0.8,
    ),
  );
}

// ── Username field ────────────────────────────────────────────────────────────

class _UsernameField extends StatelessWidget {
  final AuthController ctrl;
  const _UsernameField({required this.ctrl});

  @override
  Widget build(BuildContext context) => _InputShell(
    child: TextField(
      controller: ctrl.usernameController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: GoogleFonts.inter(
        fontSize: 14, color: AppColors.ink,
      ),
      decoration: InputDecoration(
        hintText: 'email@donvi.gov.vn',
        hintStyle: GoogleFonts.inter(
          fontSize: 14, color: AppColors.inkFaint,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 15),
      ),
    ),
  );
}

// ── Password field ────────────────────────────────────────────────────────────

class _PasswordField extends StatelessWidget {
  final AuthController ctrl;
  const _PasswordField({required this.ctrl});

  @override
  Widget build(BuildContext context) => Obx(() => _InputShell(
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: ctrl.passwordController,
            obscureText: !ctrl.passwordVisible.value,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => ctrl.login(),
            style: GoogleFonts.inter(
              fontSize: 15, color: AppColors.ink,
              letterSpacing: ctrl.passwordVisible.value ? 0 : 2,
            ),
            decoration: InputDecoration(
              hintText: '••••••••••',
              hintStyle: GoogleFonts.inter(
                fontSize: 15, color: AppColors.inkFaint,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 15),
            ),
          ),
        ),
        GestureDetector(
          onTap: ctrl.togglePasswordVisibility,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              ctrl.passwordVisible.value ? 'Ẩn' : 'Hiện',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    ),
  ));
}

// ── Input shell (white card, hairline border) ─────────────────────────────────

class _InputShell extends StatelessWidget {
  final Widget child;
  const _InputShell({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.canvas,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.hairline),
      boxShadow: [
        BoxShadow(
          color: AppColors.ink.withValues(alpha: 0.04),
          blurRadius: 8, offset: const Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}

// ── Login button ──────────────────────────────────────────────────────────────

class _LoginButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;
  const _LoginButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: loading ? null : onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 54,
      decoration: BoxDecoration(
        color: loading
            ? AppColors.tileDark.withValues(alpha: 0.55)
            : AppColors.tileDark,
        borderRadius: BorderRadius.circular(27),
      ),
      child: Center(
        child: loading
            ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Đăng nhập',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      size: 16, color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}
