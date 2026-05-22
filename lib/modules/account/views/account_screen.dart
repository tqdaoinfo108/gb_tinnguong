import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/account_controller.dart';
import 'profile_edit_screen.dart';
import 'change_password_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl   = Get.find<AccountController>();
    final top    = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          // ── Hero ──────────────────────────────────────────────
          SliverToBoxAdapter(child: _Hero(ctrl: ctrl, top: top)),


          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Section: Tài khoản ────────────────────────────────
          SliverToBoxAdapter(
            child: _SettingsCard(items: [
              _RowItem(
                icon: Icons.person_outline_rounded,
                iconBg: AppColors.blueBg,
                iconFg: AppColors.primary,
                title: 'Thông tin cá nhân',
                subtitle: 'Họ tên, mã CB, đơn vị, điện thoại',
                trailing: _chevron,
                onTap: () => Get.to(() => const ProfileEditScreen(),
                    transition: Transition.cupertino),
              ),
              _RowItem(
                icon: Icons.lock_outline_rounded,
                iconBg: AppColors.amberBg,
                iconFg: AppColors.amberFg,
                title: 'Bảo mật & đăng nhập',
                subtitle: 'Đổi mật khẩu · phiên đăng nhập',
                trailing: _chevron,
                onTap: () => Get.to(() => const ChangePasswordScreen(),
                    transition: Transition.cupertino),
              ),
              _RowItem(
                icon: Icons.bookmark_border_rounded,
                iconBg: AppColors.emeraldBg,
                iconFg: AppColors.emeraldFg,
                title: 'Mục đã lưu',
                subtitle: '8 cơ sở · 3 sự kiện · 12 tin',
                trailing: _chevron,
                divider: false,
              ),
            ]),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Section: Cài đặt ─────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() => _SettingsCard(items: [
              _RowItem(
                icon: Icons.notifications_outlined,
                iconBg: AppColors.blueBg,
                iconFg: AppColors.primary,
                title: 'Thông báo',
                subtitle: 'Cảnh báo · sự kiện · tin mới',
                trailing: _PillToggle(
                  value: ctrl.notifEnabled.value,
                  onChanged: (v) => ctrl.notifEnabled.value = v,
                ),
              ),
              _RowItem(
                icon: Icons.map_outlined,
                iconBg: AppColors.slateBg,
                iconFg: AppColors.inkMuted,
                title: 'Lớp bản đồ mặc định',
                subtitle: 'Hành chính · vệ tinh · địa hình',
                trailing: _ValueChip(ctrl.mapLayer.value),
                onTap: () => _showMapLayerPicker(ctrl),
              ),
              _RowItem(
                icon: Icons.palette_outlined,
                iconBg: AppColors.goldPillBg,
                iconFg: AppColors.goldPillFg,
                title: 'Giao diện',
                trailing: _ValueChip(ctrl.themeMode.value),
                onTap: () => _showThemePicker(ctrl),
              ),
              _RowItem(
                icon: Icons.sync_rounded,
                iconBg: AppColors.emeraldBg,
                iconFg: AppColors.emeraldFg,
                title: 'Đồng bộ dữ liệu',
                subtitle: ctrl.lastSyncLabel.value,
                trailing: ctrl.isLoading.value
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                    : Icon(Icons.refresh_rounded, size: 18, color: AppColors.primary),
                onTap: ctrl.syncNow,
                divider: false,
              ),
            ])),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Section: Hỗ trợ ──────────────────────────────────
          SliverToBoxAdapter(
            child: _SettingsCard(items: [
              _RowItem(
                icon: Icons.help_outline_rounded,
                iconBg: AppColors.blueBg,
                iconFg: AppColors.primary,
                title: 'Hướng dẫn sử dụng',
                trailing: _chevron,
              ),
              _RowItem(
                icon: Icons.support_agent_outlined,
                iconBg: AppColors.slateBg,
                iconFg: AppColors.inkMuted,
                title: 'Liên hệ kỹ thuật',
                subtitle: 'phongnoivu.p5@bt.hcm.gov.vn',
                trailing: _chevron,
              ),
              _RowItem(
                icon: Icons.description_outlined,
                iconBg: AppColors.slateBg,
                iconFg: AppColors.inkMuted,
                title: 'Điều khoản & quyền riêng tư',
                trailing: _chevron,
                divider: false,
              ),
            ]),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Logout ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _LogoutButton(onTap: () => _confirmLogout(ctrl)),
            ),
          ),

          // ── Footer ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, bottom + 100),
              child: Column(
                children: [
                  Text(
                    'Tín Ngưỡng · v 1.0.0 · build 2026.05',
                    style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.inkFaint,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Obx(() {
                    final wu = ctrl.displayWorkUnit;
                    if (wu == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        wu,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.inkFaint.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget get _chevron =>
      Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.inkFaint);

  void _showMapLayerPicker(AccountController ctrl) {
    Get.bottomSheet(
      _SimpleSheet(
        title: 'Lớp bản đồ mặc định',
        options: const ['Hành chính', 'Vệ tinh', 'Địa hình'],
        selected: ctrl.mapLayer.value,
        onSelect: (v) => ctrl.mapLayer.value = v,
      ),
    );
  }

  void _showThemePicker(AccountController ctrl) {
    Get.bottomSheet(
      _SimpleSheet(
        title: 'Giao diện',
        options: const ['Tự động', 'Sáng', 'Tối'],
        selected: ctrl.themeMode.value,
        onSelect: (v) => ctrl.themeMode.value = v,
      ),
    );
  }

  void _confirmLogout(AccountController ctrl) {
    Get.bottomSheet(
      _LogoutSheet(ctrl: ctrl),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

// ── Hero ──────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  final AccountController ctrl;
  final double top;
  const _Hero({required this.ctrl, required this.top});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E2D3D), Color(0xFF243345)],
        ),
      ),
      child: Stack(
        children: [
          // Dot pattern
          Positioned.fill(child: CustomPaint(painter: _HeroDots())),

          Padding(
            padding: EdgeInsets.fromLTRB(20, top + 20, 20, 28),
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title bar
                Text('Tài khoản', style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.45),
                  letterSpacing: 1.5,
                )),

                const SizedBox(height: 20),

                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF3B6FA0), Color(0xFF2F5B85)],
                        ),
                        border: Border.all(color: AppColors.gold, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.3),
                            blurRadius: 12, spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          ctrl.initials,
                          style: GoogleFonts.inter(
                            fontSize: 22, fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ctrl.displayName, style: GoogleFonts.inter(
                            fontSize: 18, fontWeight: FontWeight.w700,
                            color: Colors.white, height: 1.2,
                          )),
                          const SizedBox(height: 3),
                          // Chức vụ
                          if (ctrl.displayRole.isNotEmpty)
                            Text(ctrl.displayRole, style: GoogleFonts.inter(
                              fontSize: 13, color: AppColors.onDarkMuted,
                            )),
                          // Đơn vị
                          if (ctrl.displayUnit.isNotEmpty) ...[
                            const SizedBox(height: 1),
                            Text(ctrl.displayUnit, style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.onDarkMuted.withValues(alpha: 0.75),
                            )),
                          ],
                          // Email hoặc phone
                          if (ctrl.displayEmail.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.alternate_email_rounded,
                                    size: 10,
                                    color: AppColors.onDarkMuted.withValues(alpha: 0.5)),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(ctrl.displayEmail,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.onDarkMuted.withValues(alpha: 0.65),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ] else if (ctrl.displayPhone.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.phone_outlined,
                                    size: 10,
                                    color: AppColors.onDarkMuted.withValues(alpha: 0.5)),
                                const SizedBox(width: 3),
                                Text(ctrl.displayPhone, style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.onDarkMuted.withValues(alpha: 0.65),
                                )),
                              ],
                            ),
                          ],
                          const SizedBox(height: 8),
                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.emeraldBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5, height: 5,
                                  decoration: const BoxDecoration(
                                    color: AppColors.emeraldFg,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text('Đang hoạt động', style: GoogleFonts.inter(
                                  fontSize: 11, fontWeight: FontWeight.w600,
                                  color: AppColors.emeraldFg,
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Edit button
                    GestureDetector(
                      onTap: () => Get.to(() => const ProfileEditScreen(),
                          transition: Transition.cupertino),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: const Icon(Icons.edit_outlined,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

// ── Settings card ─────────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final List<_RowItem> items;
  const _SettingsCard({required this.items});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: AppColors.canvas,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.hairline),
      boxShadow: [AppColors.lightShadow],
    ),
    child: Column(
      children: items.asMap().entries.map((e) => e.value).toList(),
    ),
  );
}

// ── Row item ──────────────────────────────────────────────────────────────────

class _RowItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool divider;

  const _RowItem({
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.onTap,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                // Icon badge
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, size: 17, color: iconFg),
                ),

                const SizedBox(width: 12),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w500,
                        color: AppColors.ink,
                      )),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!, style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.inkFaint,
                        )),
                      ],
                    ],
                  ),
                ),

                trailing,
              ],
            ),
          ),
        ),
        if (divider)
          Padding(
            padding: const EdgeInsets.only(left: 62),
            child: Divider(height: 1, color: AppColors.hairline),
          ),
      ],
    );
  }
}

// ── Toggle pill ───────────────────────────────────────────────────────────────

class _PillToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _PillToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => onChanged(!value),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44, height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: value ? AppColors.primary : AppColors.hairline,
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(3),
          width: 18, height: 18,
          decoration: const BoxDecoration(
            color: Colors.white, shape: BoxShape.circle,
          ),
        ),
      ),
    ),
  );
}

// ── Value chip ────────────────────────────────────────────────────────────────

class _ValueChip extends StatelessWidget {
  final String label;
  const _ValueChip(this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.blueBg,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(label, style: GoogleFonts.inter(
      fontSize: 12, fontWeight: FontWeight.w500,
      color: AppColors.primary,
    )),
  );
}

// ── Logout button ─────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.redBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.redFg.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, size: 17, color: AppColors.redFg),
          const SizedBox(width: 8),
          Text('Đăng xuất', style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: AppColors.redFg,
          )),
        ],
      ),
    ),
  );
}

// ── Bottom sheet picker ───────────────────────────────────────────────────────

class _SimpleSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;
  const _SimpleSheet({
    required this.title, required this.options,
    required this.selected, required this.onSelect,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: AppColors.canvas,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: AppColors.hairlineStrong,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(title, style: GoogleFonts.inter(
          fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink,
        )),
        const SizedBox(height: 12),
        ...options.map((opt) => ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(opt, style: GoogleFonts.inter(
            fontSize: 14, color: AppColors.ink,
          )),
          trailing: opt == selected
              ? const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 20)
              : const Icon(Icons.circle_outlined,
                  color: AppColors.hairlineStrong, size: 20),
          onTap: () {
            onSelect(opt);
            Get.back();
          },
        )),
      ],
    ),
  );
}

// ── Logout bottom sheet ───────────────────────────────────────────────────────

class _LogoutSheet extends StatelessWidget {
  final AccountController ctrl;
  const _LogoutSheet({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // Handle
          Center(
            child: Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.hairlineStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Icon circle
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppColors.redBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.logout_rounded,
              size: 28,
              color: AppColors.redFg,
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            'Đăng xuất?',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Bạn sẽ cần đăng nhập lại bằng tài khoản\ncông vụ để tiếp tục sử dụng ứng dụng.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.inkSoft,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          // User info card
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.parchment,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Row(
              children: [
                // Avatar badge
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.goldPillBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      ctrl.initials,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.goldPillFg,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ctrl.displayName,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      if (ctrl.displayUnit.isNotEmpty) ...[
                        const SizedBox(height: 1),
                        Text(
                          ctrl.displayUnit,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ],
                      // email hoặc username
                      ...[
                        const SizedBox(height: 2),
                        Text(
                          ctrl.displayEmail.isNotEmpty
                              ? ctrl.displayEmail
                              : ctrl.staffCode.isNotEmpty
                                  ? 'Mã CB: ${ctrl.staffCode}'
                                  : ctrl.displayRole,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.inkFaint,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          )),

          const SizedBox(height: 16),

          // Logout button
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: ctrl.logout,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.redFg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Đăng xuất',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Cancel
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: Get.back,
              child: Text(
                'Huỷ',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero dot pattern ──────────────────────────────────────────────────────────

class _HeroDots extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;
    const spacing = 24.0;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_HeroDots old) => false;
}
