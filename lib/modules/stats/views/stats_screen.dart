import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/religion_palette.dart' as palette;
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../data/models/dashboard_model.dart';
import '../controllers/stats_controller.dart';

// ─── Screen ────────────────────────────────────────────────────────────────────

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.find works because StatsBinding registered the controller when the
    // route was pushed.
    final ctrl   = Get.find<StatsController>();
    final top    = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          // ── Header ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, top + 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Thống kê', style: _hero),
                          Text(ctrl.periodLabel, style: _cap),
                        ],
                      )),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.canvas,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.hairline),
                            boxShadow: [AppColors.lightShadow],
                          ),
                          child: const Icon(Icons.download_outlined,
                              size: 18, color: AppColors.inkMuted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Period chips
                  Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(children: [
                      _PeriodChip(label: 'Tháng này', active: ctrl.typeSearch.value == 1,
                          onTap: () => ctrl.setTypeSearch(1)),
                      const SizedBox(width: 8),
                      _PeriodChip(label: 'Quý này', active: ctrl.typeSearch.value == 2,
                          onTap: () => ctrl.setTypeSearch(2)),
                      const SizedBox(width: 8),
                      _PeriodChip(label: 'Năm nay', active: ctrl.typeSearch.value == 3,
                          onTap: () => ctrl.setTypeSearch(3)),
                      const SizedBox(width: 8),
                      _PeriodChip(label: 'Tùy chọn', active: ctrl.typeSearch.value == 4,
                          onTap: () => ctrl.setTypeSearch(4)),
                    ]),
                  )),

                  // Custom date row
                  Obx(() => ctrl.typeSearch.value == 4
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: _CustomDateRow(ctrl: ctrl),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ),

          // ── Loading ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() => ctrl.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary, strokeWidth: 2),
                    ),
                  )
                : const SizedBox.shrink()),
          ),

          // ── Error ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() => ctrl.hasError.value && !ctrl.isLoading.value
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
                    child: Column(children: [
                      const Icon(Icons.cloud_off_rounded,
                          size: 42, color: AppColors.inkFaint),
                      const SizedBox(height: 12),
                      Text('Không tải được dữ liệu',
                          style: GoogleFonts.inter(
                              fontSize: 15, color: AppColors.inkSoft),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: ctrl.load,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Thử lại',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  )
                : const SizedBox.shrink()),
          ),

          // ── Hero KPI (Cơ sở tôn giáo) ───────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() {
              if (ctrl.isLoading.value || ctrl.hasError.value) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _HeroKpiCard(dashboard: ctrl.dashboard.value),
              );
            }),
          ),

          // ── 2×2 KPI grid ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() {
              if (ctrl.isLoading.value || ctrl.hasError.value) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: _KpiGrid(dashboard: ctrl.dashboard.value),
              );
            }),
          ),

          // ── Legal status donut ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() {
              final d = ctrl.dashboard.value;
              if (ctrl.isLoading.value || ctrl.hasError.value ||
                  d.statusData.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: _LegalStatusCard(dashboard: d),
              );
            }),
          ),

          // ── Profile completion radial ─────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() {
              final d = ctrl.dashboard.value;
              if (ctrl.isLoading.value || ctrl.hasError.value ||
                  d.profileData.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: _ProfileCard(data: d.profileData),
              );
            }),
          ),

          // ── Warning card ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() {
              final d = ctrl.dashboard.value;
              if (ctrl.isLoading.value || ctrl.hasError.value) {
                return const SizedBox.shrink();
              }
              final noPermit =
                  (d.totalEvent - d.totalEventPermit).clamp(0, 999);
              if (noPermit == 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: _WarningCard(noPermit: noPermit),
              );
            }),
          ),

          SliverToBoxAdapter(child: SizedBox(height: bottom + 48)),
        ],
      ),
    );
  }
}

// ─── Hero KPI ──────────────────────────────────────────────────────────────────

class _HeroKpiCard extends StatelessWidget {
  final DashboardModel dashboard;
  const _HeroKpiCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final total = dashboard.totalOffice;
    final bars  = dashboard.religionData;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CƠ SỞ TÔN GIÁO', style: _labelSm),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$total', style: GoogleFonts.inter(
                fontSize: 48, fontWeight: FontWeight.w700,
                color: AppColors.ink, letterSpacing: -0.03, height: 1,
              )),
              const SizedBox(width: 8),
              Text('cơ sở', style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.inkSoft)),
            ],
          ),
          const SizedBox(height: 18),
          if (bars.isNotEmpty)
            for (int i = 0; i < bars.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              _ReligionBar(
                label: bars[i].religionName,
                count: bars[i].total,
                max: total > 0 ? total : 1,
                color: palette.religionColor(bars[i].religionName),
              ),
            ]
          else
            Text('Chưa có dữ liệu phân bố',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.inkFaint)),
        ],
      ),
    );
  }
}

class _ReligionBar extends StatelessWidget {
  final String label;
  final int    count, max;
  final Color  color;
  const _ReligionBar({required this.label, required this.count,
      required this.max, required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = (count / max).clamp(0.0, 1.0);
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(width: 8, height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 7),
            Text(label, style: GoogleFonts.inter(
                fontSize: 13, color: AppColors.inkMuted)),
          ]),
          Text('$count', style: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
        ],
      ),
      const SizedBox(height: 5),
      ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: LinearProgressIndicator(
          value: pct, minHeight: 6,
          backgroundColor: AppColors.parchment2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    ]);
  }
}

// ─── 2×2 KPI grid ─────────────────────────────────────────────────────────────

class _KpiGrid extends StatelessWidget {
  final DashboardModel dashboard;
  const _KpiGrid({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final d         = dashboard;
    final permitStr = d.totalEvent > 0
        ? '${d.totalEventPermit}/${d.totalEvent}'
        : '${d.totalEventPermit}';
    final noPermit  = (d.totalEvent - d.totalEventPermit).clamp(0, 999);

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10, mainAxisSpacing: 10,
      childAspectRatio: 1.55,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _KpiTile(
          icon: Icons.person_outline_rounded,
          color: AppColors.primary,
          label: 'CHỨC SẮC – CHỨC VIỆC',
          value: '${d.totalUser}',
          unit: 'người',
        ),
        _KpiTile(
          icon: Icons.celebration_outlined,
          color: AppColors.caodai,
          label: 'LỄ HỘI CÓ PHÉP',
          value: permitStr,
          unit: d.totalEvent > 0 ? 'đã cấp / ${d.totalEvent}' : 'cấp phép',
        ),
        _KpiTile(
          icon: Icons.square_foot_outlined,
          color: AppColors.folk,
          label: 'DIỆN TÍCH ĐẤT',
          value: _fmtArea(d.totalArea),
          unit: 'm²',
        ),
        _KpiTile(
          icon: noPermit > 0
              ? Icons.warning_amber_rounded
              : Icons.check_circle_outline_rounded,
          color: noPermit > 0 ? AppColors.amberDot : AppColors.emeraldDot,
          label: 'LỄ HỘI CHƯA PHÉP',
          value: '$noPermit',
          unit: 'sự kiện',
          alert: noPermit > 0,
        ),
      ],
    );
  }
}

class _KpiTile extends StatelessWidget {
  final IconData icon;
  final Color    color;
  final String   label, value, unit;
  final bool     alert;
  const _KpiTile({
    required this.icon, required this.color,
    required this.label, required this.value, required this.unit,
    this.alert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: alert ? AppColors.amberBg : AppColors.canvas,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: alert
              ? AppColors.amberDot.withValues(alpha: 0.35)
              : AppColors.hairline,
        ),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const Spacer(),
          Text(value, style: GoogleFonts.inter(
            fontSize: 22, fontWeight: FontWeight.w700,
            color: alert ? AppColors.amberFg : AppColors.ink,
            letterSpacing: -0.02, height: 1.1,
          )),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.inter(
            fontSize: 9, fontWeight: FontWeight.w500,
            color: alert ? AppColors.amberFg : AppColors.inkSoft,
            letterSpacing: 0.04,
          )),
        ],
      ),
    );
  }
}

// ─── Legal status donut ────────────────────────────────────────────────────────

class _LegalStatusCard extends StatelessWidget {
  final DashboardModel dashboard;
  const _LegalStatusCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final data  = dashboard.statusData;
    final total = data.fold<int>(0, (s, e) => s + e.total);
    final segs  = data.map((s) => _DonutSeg(
      value: s.total.toDouble(),
      color: _statusColor(s.statusID, s.statusName),
    )).toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tình trạng pháp lý', style: _cardTitle),
          const SizedBox(height: 14),
          Row(children: [
            SizedBox(
              width: 110, height: 110,
              child: CustomPaint(
                painter: _DonutPainter(segs: segs, total: total.toDouble()),
                child: Center(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$total', style: GoogleFonts.inter(
                      fontSize: 22, fontWeight: FontWeight.w700,
                      color: AppColors.ink, letterSpacing: -0.02, height: 1,
                    )),
                    Text('CƠ SỞ', style: GoogleFonts.inter(
                        fontSize: 9, color: AppColors.inkSoft,
                        letterSpacing: 0.08)),
                  ],
                )),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(child: Column(
              children: [
                for (int i = 0; i < data.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  _LegRow(
                    color: _statusColor(data[i].statusID, data[i].statusName),
                    label: data[i].statusName,
                    value: '${data[i].total}',
                  ),
                ],
              ],
            )),
          ]),
        ],
      ),
    );
  }

  Color _statusColor(int? id, String name) {
    if (id != null) {
      return switch (id) {
        1 => const Color(0xFF2A8A5A),
        2 => const Color(0xFFB8870C),
        3 => AppColors.inkSoft,
        4 => const Color(0xFFB03328),
        _ => AppColors.inkFaint,
      };
    }
    final n = name.toLowerCase();
    if (n.contains('công nhận') || n.contains('đã đăng')) {
      return const Color(0xFF2A8A5A);
    }
    if (n.contains('xét') || n.contains('chờ') || n.contains('đang')) {
      return const Color(0xFFB8870C);
    }
    if (n.contains('đình chỉ') || n.contains('hủy')) {
      return const Color(0xFFB03328);
    }
    return AppColors.inkSoft;
  }
}

class _DonutSeg {
  final double value;
  final Color  color;
  const _DonutSeg({required this.value, required this.color});
}

class _DonutPainter extends CustomPainter {
  final List<_DonutSeg> segs;
  final double total;
  const _DonutPainter({required this.segs, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r      = size.width / 2 - 8;
    const sw     = 14.0;
    const gap    = 0.04;

    canvas.drawCircle(center, r,
        Paint()
          ..color = AppColors.hairline
          ..style = PaintingStyle.stroke
          ..strokeWidth = sw);

    if (total <= 0) return;

    double start = -math.pi / 2;
    for (final seg in segs) {
      final sweep = (seg.value / total) * 2 * math.pi - gap;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        start, sweep.clamp(0.0, 2 * math.pi), false,
        Paint()
          ..color = seg.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = sw
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter o) => o.total != total;
}

class _LegRow extends StatelessWidget {
  final Color color; final String label, value;
  const _LegRow({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 9, height: 9,
        decoration: BoxDecoration(color: color,
            borderRadius: BorderRadius.circular(3))),
    const SizedBox(width: 8),
    Expanded(child: Text(label, style: GoogleFonts.inter(
        fontSize: 13, color: AppColors.inkMuted))),
    Text(value, style: GoogleFonts.inter(
        fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
  ]);
}

// ─── Profile radial ────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final List<ProfileBreakdown> data;
  const _ProfileCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final total  = data.fold<int>(0, (s, e) => s + e.total);
    if (total == 0) return const SizedBox.shrink();

    const colors = [AppColors.primary, AppColors.amberDot, AppColors.inkSoft];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hoàn thiện hồ sơ', style: _cardTitle),
          const SizedBox(height: 16),
          Row(children: [
            SizedBox(
              width: 110, height: 110,
              child: CustomPaint(
                painter: _RadialPainter(
                  segs: [
                    for (int i = 0; i < data.length; i++)
                      _RadSeg(
                        pct: data[i].total / total,
                        color: colors[i % colors.length],
                        radius: 42.0 - i * 12,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(child: Column(
              children: [
                for (int i = 0; i < data.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  _LegRow(
                    color: colors[i % colors.length],
                    label: data[i].label,
                    value: '${data[i].total}',
                  ),
                ],
              ],
            )),
          ]),
        ],
      ),
    );
  }
}

class _RadSeg {
  final double pct, radius;
  final Color  color;
  const _RadSeg({required this.pct, required this.color, required this.radius});
}

class _RadialPainter extends CustomPainter {
  final List<_RadSeg> segs;
  const _RadialPainter({required this.segs});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (final s in segs) {
      canvas.drawCircle(center, s.radius,
          Paint()
            ..color = AppColors.hairline
            ..style = PaintingStyle.stroke
            ..strokeWidth = 8);
      if (s.pct > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: s.radius),
          -math.pi / 2, s.pct * 2 * math.pi, false,
          Paint()
            ..color = s.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 8
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RadialPainter o) => false;
}

// ─── Warning card ──────────────────────────────────────────────────────────────

class _WarningCard extends StatelessWidget {
  final int noPermit;
  const _WarningCard({required this.noPermit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.amberBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.amberDot.withValues(alpha: 0.3)),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.amberDot.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.warning_amber_rounded,
                size: 18, color: AppColors.amberDot),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$noPermit sự kiện chưa có giấy phép',
                  style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w600,
                    color: AppColors.amberFg,
                  )),
              const SizedBox(height: 3),
              Text('Cần bổ sung hồ sơ trước khi tổ chức',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.amberFg
                          .withValues(alpha: 0.8))),
            ],
          )),
        ],
      ),
    );
  }
}

// ─── Period chip ───────────────────────────────────────────────────────────────

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool   active;
  final VoidCallback onTap;
  const _PeriodChip(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.canvas,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
              color: active ? AppColors.primary : AppColors.hairline),
          boxShadow: active ? [] : [AppColors.lightShadow],
        ),
        child: Text(label, style: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w600,
          color: active ? Colors.white : AppColors.inkMuted,
        )),
      ),
    );
  }
}

// ─── Custom date row ───────────────────────────────────────────────────────────

class _CustomDateRow extends StatelessWidget {
  final StatsController ctrl;
  const _CustomDateRow({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final from = ctrl.customFrom.value;
      final to   = ctrl.customTo.value;
      return Row(children: [
        Expanded(
          child: _DateField(
            label: 'Từ ngày',
            value: from,
            onPick: (d) {
              ctrl.customFrom.value = d;
              final t = ctrl.customTo.value;
              if (t != null && !d.isAfter(t)) ctrl.load();
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DateField(
            label: 'Đến ngày',
            value: to,
            onPick: (d) {
              ctrl.customTo.value = d;
              final f = ctrl.customFrom.value;
              if (f != null && !d.isBefore(f)) ctrl.load();
            },
          ),
        ),
      ]);
    });
  }
}

class _DateField extends StatelessWidget {
  final String    label;
  final DateTime? value;
  final void Function(DateTime) onPick;
  const _DateField(
      {required this.label, this.value, required this.onPick});

  @override
  Widget build(BuildContext context) {
    final display = value != null
        ? '${_p(value!.day)}/${_p(value!.month)}/${value!.year}'
        : label;

    return GestureDetector(
      onTap: () async {
        final now  = DateTime.now();
        final pick = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(now.year - 3),
          lastDate: DateTime(now.year + 2),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme:
                  const ColorScheme.light(primary: AppColors.primary),
            ),
            child: child!,
          ),
        );
        if (pick != null) onPick(pick);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(children: [
          const Icon(Icons.calendar_today_outlined,
              size: 14, color: AppColors.inkSoft),
          const SizedBox(width: 7),
          Expanded(child: Text(display, style: GoogleFonts.inter(
            fontSize: 13,
            color: value != null ? AppColors.ink : AppColors.inkFaint,
            fontWeight:
                value != null ? FontWeight.w500 : FontWeight.w400,
          ))),
        ]),
      ),
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────────────────────

String _fmtArea(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) {
    return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
  }
  return '$n';
}

String _p(int n) => n.toString().padLeft(2, '0');

// ─── Text styles ───────────────────────────────────────────────────────────────

final _hero      = AppTextStyles.hero;
final _cap       = AppTextStyles.cap;
final _cardTitle = GoogleFonts.inter(
  fontSize: 17, fontWeight: FontWeight.w600,
  color: AppColors.ink, letterSpacing: -0.01,
);
final _labelSm = GoogleFonts.inter(
  fontSize: 11, fontWeight: FontWeight.w500,
  color: AppColors.inkSoft, letterSpacing: 0.05,
);
