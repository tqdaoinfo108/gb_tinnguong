import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
class ClergyDetailScreen extends StatelessWidget {
  const ClergyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _DarkHeader(top: top, context: context)),
          SliverToBoxAdapter(child: _InfoCard()),
          SliverToBoxAdapter(child: _NoteBox()),
          SliverToBoxAdapter(child: _ActionRow()),
          const SliverToBoxAdapter(child: SizedBox(height: 110)),
        ],
      ),
    );
  }
}

// ─── Dark Header ───────────────────────────────────────────────

class _DarkHeader extends StatelessWidget {
  final double top;
  final BuildContext context;
  const _DarkHeader({required this.top, required this.context});

  @override
  Widget build(BuildContext _) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.tileDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, top + 8, 20, 28),
      child: Column(
        children: [
          // Nav row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DarkBtn(icon: Icons.chevron_left_rounded, size: 24,
                  onTap: () => Navigator.of(context).pop()),
              _DarkBtn(icon: Icons.ios_share_rounded, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          // Avatar
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(
              color: AppColors.goldPillBg,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 3),
            ),
            child: Center(child: Text('TQ', style: GoogleFonts.inter(
              fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.goldPillFg,
            ))),
          ),
          const SizedBox(height: 14),
          Text('Thượng toạ Thích Trí Quảng', style: GoogleFonts.inter(
            fontSize: 24, fontWeight: FontWeight.w700,
            color: Colors.white, letterSpacing: -0.02,
          ), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Trụ trì · Chùa Pháp Hoa', style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onDarkMuted,
          )),
          const SizedBox(height: 12),
          // Pills
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 6, height: 6,
                      decoration: const BoxDecoration(color: AppColors.buddhism, shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('Phật giáo', style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white,
                  )),
                ]),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0x38228A5A),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 6, height: 6,
                      decoration: const BoxDecoration(color: Color(0xFF5CD99A), shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('Đang hoạt động', style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFA8E4C2),
                  )),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DarkBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback? onTap;
  const _DarkBtn({required this.icon, this.size = 20, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Icon(icon, size: size, color: Colors.white),
      ),
    );
  }
}

// ─── Info Card ─────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.hairline),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(children: const [
          _InfoRow(label: 'Năm sinh', value: '1959 · 67 tuổi'),
          _InfoRow(label: 'Quê quán', value: 'Thừa Thiên Huế'),
          _InfoRow(label: 'Đảm nhiệm từ', value: '1996'),
          _InfoRow(label: 'Cơ sở', value: 'Chùa Pháp Hoa'),
          _InfoRow(label: 'Khu phố', value: 'Khu phố 4, Phường 5'),
          _InfoRow(label: 'Điện thoại', value: '028 3551 2xxx', mono: true),
          _InfoRow(label: 'Email', value: 'trutri.phaphoa@pg.vn', mono: true, last: true),
        ]),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final bool mono, last;
  const _InfoRow({required this.label, required this.value, this.mono = false, this.last = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: last ? null : Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.inkSoft)),
          Text(value,
            style: mono
                ? GoogleFonts.jetBrainsMono(fontSize: 13, color: AppColors.ink)
                : GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}

// ─── Note Box ──────────────────────────────────────────────────

class _NoteBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFBF1D9), Color(0xFFF7E6BF)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFECD9A6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GHI CHÚ', style: GoogleFonts.inter(
              fontSize: 11, fontWeight: FontWeight.w600,
              color: const Color(0xFF8A6310), letterSpacing: 0.05,
            )),
            const SizedBox(height: 4),
            Text(
              'Phụ trách Ban Hoằng pháp Giáo hội Phật giáo Quận Bình Thạnh nhiệm kỳ 2022–2027.',
              style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF735A14), height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Action Row ────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(children: [
        Expanded(child: _PrimaryBtn(icon: Icons.phone_rounded, label: 'Gọi điện')),
        const SizedBox(width: 8),
        Expanded(child: _GhostBtn(icon: Icons.mail_outline_rounded, label: 'Email')),
      ]),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PrimaryBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,
          )),
        ],
      ),
    );
  }
}

class _GhostBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  const _GhostBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.inkMuted),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.inkMuted,
          )),
        ],
      ),
    );
  }
}
