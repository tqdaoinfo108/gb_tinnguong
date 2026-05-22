import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/account_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _ctrl = Get.find<AccountController>();

  final _oldPw  = TextEditingController();
  final _newPw  = TextEditingController();
  final _confPw = TextEditingController();

  bool _showOld  = false;
  bool _showNew  = false;
  bool _showConf = false;

  @override
  void dispose() {
    _oldPw.dispose();
    _newPw.dispose();
    _confPw.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await _ctrl.changePassword(
      oldPassword:     _oldPw.text,
      newPassword:     _newPw.text,
      confirmPassword: _confPw.text,
    );
    if (ok && mounted) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final top    = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: Column(
        children: [

          // ── Top bar ───────────────────────────────────────────
          Container(
            color: AppColors.canvas,
            padding: EdgeInsets.fromLTRB(4, top + 8, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
                  onPressed: Get.back,
                ),
                Expanded(
                  child: Text('Đổi mật khẩu', style: GoogleFonts.inter(
                    fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink,
                  )),
                ),
              ],
            ),
          ),

          // ── Body ──────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 28, 20, bottom + 32),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Illustration / icon
                  Center(
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.amberBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        size: 36,
                        color: AppColors.amberFg,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      'Bảo mật tài khoản',
                      style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Center(
                    child: Text(
                      'Mật khẩu mới phải có ít nhất 6 ký tự.',
                      style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.inkSoft, height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Form
                  _SectionLabel('MẬT KHẨU HIỆN TẠI'),
                  const SizedBox(height: 8),
                  _PwCard(
                    controller: _oldPw,
                    hint: 'Nhập mật khẩu hiện tại',
                    show: _showOld,
                    onToggle: () => setState(() => _showOld = !_showOld),
                  ),

                  const SizedBox(height: 20),

                  _SectionLabel('MẬT KHẨU MỚI'),
                  const SizedBox(height: 8),
                  _PwCard(
                    controller: _newPw,
                    hint: 'Nhập mật khẩu mới',
                    show: _showNew,
                    onToggle: () => setState(() => _showNew = !_showNew),
                  ),

                  const SizedBox(height: 20),

                  _SectionLabel('XÁC NHẬN MẬT KHẨU'),
                  const SizedBox(height: 8),
                  _PwCard(
                    controller: _confPw,
                    hint: 'Nhập lại mật khẩu mới',
                    show: _showConf,
                    onToggle: () => setState(() => _showConf = !_showConf),
                  ),

                  const SizedBox(height: 36),

                  // Confirm button
                  Obx(() => _SubmitButton(
                    loading: _ctrl.isSaving.value,
                    onTap: _ctrl.isSaving.value ? null : _submit,
                  )),

                  const SizedBox(height: 16),

                  // Tips
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.blueBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Sau khi đổi mật khẩu thành công, bạn có thể tiếp tục sử dụng ứng dụng bình thường.',
                            style: GoogleFonts.inter(
                              fontSize: 12, color: AppColors.blueFg,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text, style: GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w700,
    color: AppColors.primary, letterSpacing: 0.8,
  ));
}

// ── Password card ─────────────────────────────────────────────────────────────

class _PwCard extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool show;
  final VoidCallback onToggle;
  const _PwCard({
    required this.controller, required this.hint,
    required this.show, required this.onToggle,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.canvas,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.hairline),
      boxShadow: [AppColors.lightShadow],
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: !show,
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.ink),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                  fontSize: 14, color: AppColors.inkFaint),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              show ? 'Ẩn' : 'Hiện',
              style: GoogleFonts.inter(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// ── Submit button ─────────────────────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onTap;
  const _SubmitButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: onTap != null ? AppColors.tileDark : AppColors.hairlineStrong,
        borderRadius: BorderRadius.circular(27),
      ),
      child: loading
          ? const Center(
              child: SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              ),
            )
          : Text(
              'Xác nhận đổi mật khẩu',
              style: GoogleFonts.inter(
                fontSize: 15, fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
    ),
  );
}
