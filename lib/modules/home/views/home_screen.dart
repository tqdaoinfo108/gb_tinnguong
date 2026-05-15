import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../widgets/img_placeholder.dart';
import '../../../widgets/status_pill.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _HeroBlock()),
          SliverToBoxAdapter(child: _AlertsSection()),
          SliverToBoxAdapter(child: _UpcomingEventsSection()),
          SliverToBoxAdapter(child: _NewsSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ─── Hero ──────────────────────────────────────────────────────
class _HeroBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.tileDark,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.85, -0.9),
                  radius: 0.85,
                  colors: [
                    AppColors.gold.withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, top + 24, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TIN NGƯỠNG · GIS', style: GoogleFonts.inter(
                  fontSize: 11, fontWeight: FontWeight.w500,
                  color: AppColors.goldSoft, letterSpacing: 0.08,
                )),
                const SizedBox(height: 6),
                Text('Chào buổi sáng', style: GoogleFonts.inter(
                  fontSize: 28, fontWeight: FontWeight.w700,
                  color: AppColors.onDark, letterSpacing: -0.02, height: 1.15,
                )),
                const SizedBox(height: 4),
                Text('Phường 5 · Quận Bình Thạnh', style: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w400,
                  color: AppColors.onDarkMuted,
                )),
                const SizedBox(height: 22),
                Row(children: [
                  Expanded(child: _KpiMini(value: '48', label: 'Cơ sở', tone: _KpiTone.ok)),
                  const SizedBox(width: 10),
                  Expanded(child: _KpiMini(value: '12', label: 'Sự kiện 2026', tone: _KpiTone.info)),
                  const SizedBox(width: 10),
                  Expanded(child: _KpiMini(value: '5', label: 'Cần xử lý', tone: _KpiTone.warn)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _KpiTone { ok, info, warn }

class _KpiMini extends StatelessWidget {
  final String value;
  final String label;
  final _KpiTone tone;
  const _KpiMini({required this.value, required this.label, required this.tone});

  @override
  Widget build(BuildContext context) {
    final labelColor = switch (tone) {
      _KpiTone.ok   => AppColors.goldSoft,
      _KpiTone.info => const Color(0xFFA9C7E3),
      _KpiTone.warn => const Color(0xFFF0C878),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: GoogleFonts.inter(
            fontSize: 24, fontWeight: FontWeight.w700,
            color: AppColors.onDark, letterSpacing: -0.02, height: 1.05,
          )),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w500, color: labelColor,
          )),
        ],
      ),
    );
  }
}

// ─── Alerts ────────────────────────────────────────────────────
class _AlertsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Cảnh báo', style: _h2),
              Text('5 mục', style: GoogleFonts.inter(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.amberFg,
              )),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [AppColors.cardShadow],
            ),
            child: Column(children: [
              _AlertRow(severity: 'high', title: 'Lễ hội chưa có giấy phép',
                  meta: 'Lễ Vu Lan · Chùa Pháp Hoa · còn 6 ngày'),
              const Divider(color: AppColors.hairline, thickness: 1, height: 1),
              _AlertRow(severity: 'med', title: 'Hồ sơ thiếu giấy chứng nhận',
                  meta: 'Nhà thờ Hiển Linh · cập nhật 12/05'),
              const Divider(color: AppColors.hairline, thickness: 1, height: 1),
              _AlertRow(severity: 'low', title: 'Sửa chữa đang thực hiện',
                  meta: 'Đình Thần Thắng Tam · từ 03/05'),
            ]),
          ),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final String severity;
  final String title;
  final String meta;
  const _AlertRow({required this.severity, required this.title, required this.meta});

  @override
  Widget build(BuildContext context) {
    final dotColor = switch (severity) {
      'high' => AppColors.redDot,
      'med'  => AppColors.amberDot,
      _      => AppColors.primary,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                width: 7, height: 7,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _bodyStrong),
                const SizedBox(height: 2),
                Text(meta, style: _cap),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.inkFaint),
        ],
      ),
    );
  }
}

// ─── Upcoming Events ───────────────────────────────────────────
class _UpcomingEventsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sắp diễn ra', style: _h2),
              Text('Tất cả ›', style: GoogleFonts.inter(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary,
              )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            children: const [
              _EventCardSmall(date: '18', month: 'THG 5', name: 'Lễ Phật Đản',
                  place: 'Chùa Pháp Hoa', religionColor: AppColors.buddhism, permit: true),
              SizedBox(width: 12),
              _EventCardSmall(date: '22', month: 'THG 5', name: 'Lễ Hiệp Thông',
                  place: 'Nhà thờ Hiển Linh', religionColor: AppColors.catholic, permit: true),
              SizedBox(width: 12),
              _EventCardSmall(date: '01', month: 'THG 6', name: 'Lễ giỗ Đức Hộ Pháp',
                  place: 'Thánh thất Cao Đài', religionColor: AppColors.caodai, permit: false),
              SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventCardSmall extends StatelessWidget {
  final String date;
  final String month;
  final String name;
  final String place;
  final Color religionColor;
  final bool permit;
  const _EventCardSmall({
    required this.date, required this.month, required this.name,
    required this.place, required this.religionColor, required this.permit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(date, style: GoogleFonts.inter(
                fontSize: 28, fontWeight: FontWeight.w700,
                letterSpacing: -0.02, height: 1, color: AppColors.ink,
              )),
              const SizedBox(width: 6),
              Text(month, style: GoogleFonts.inter(
                fontSize: 11, fontWeight: FontWeight.w500,
                color: AppColors.inkSoft, letterSpacing: 0.02,
              )),
            ],
          ),
          const SizedBox(height: 10),
          Text(name, style: _h3, maxLines: 2),
          const SizedBox(height: 6),
          Row(children: [
            Container(width: 6, height: 6,
                decoration: BoxDecoration(color: religionColor, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Expanded(child: Text(place, style: _cap, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
          const SizedBox(height: 12),
          StatusPill(
            kind: permit ? PillKind.emerald : PillKind.amber,
            label: permit ? 'Đã cấp phép' : 'Chưa có phép',
          ),
        ],
      ),
    );
  }
}

// ─── News ──────────────────────────────────────────────────────
class _NewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tin mới', style: _h2),
              Text('Tất cả ›', style: GoogleFonts.inter(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary,
              )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.canvas,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [AppColors.cardShadow],
          ),
          child: Column(children: [
            _NewsRow(tag: 'công nhận', kind: PillKind.emerald,
                title: 'Trao quyết định công nhận cơ sở Tịnh xá Ngọc Phương',
                date: '14/05/2026', variant: ImgVariant.warm),
            const Divider(color: AppColors.hairline, thickness: 1, height: 1),
            _NewsRow(tag: 'hoạt động', kind: PillKind.blue,
                title: 'Hội nghị liên tôn Phường 5 chuẩn bị Đại lễ Phật Đản',
                date: '12/05/2026', variant: ImgVariant.sage),
            const Divider(color: AppColors.hairline, thickness: 1, height: 1),
            _NewsRow(tag: 'thông báo', kind: PillKind.slate,
                title: 'Lịch tiếp dân tháng 5 — Phòng Nội vụ',
                date: '10/05/2026', variant: ImgVariant.light),
          ]),
        ),
      ],
    );
  }
}

class _NewsRow extends StatelessWidget {
  final String tag;
  final PillKind kind;
  final String title;
  final String date;
  final ImgVariant variant;
  const _NewsRow({
    required this.tag, required this.kind,
    required this.title, required this.date, required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImgPlaceholder(
            width: 60, height: 60,
            tag: tag.substring(0, tag.length.clamp(0, 3)),
            variant: variant,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusPill(kind: kind, label: tag, fontSize: 10.5),
                const SizedBox(height: 6),
                Text(title, style: _bodyStrong, maxLines: 2),
                const SizedBox(height: 4),
                Text(date, style: _cap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Typography ────────────────────────────────────────────────
final _h2 = GoogleFonts.inter(
  fontSize: 19, fontWeight: FontWeight.w600,
  color: AppColors.ink, letterSpacing: -0.015,
);
final _h3 = GoogleFonts.inter(
  fontSize: 16, fontWeight: FontWeight.w600,
  color: AppColors.ink, letterSpacing: -0.01,
);
final _bodyStrong = AppTextStyles.bodyStrong;
final _cap = AppTextStyles.cap;
