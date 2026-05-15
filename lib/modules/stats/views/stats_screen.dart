import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../widgets/circle_icon_button.dart';
import '../../../widgets/filter_chip.dart';
import '../../../widgets/status_pill.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, top + 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Thống kê', style: _hero),
                        Text('Phường 5 · Năm 2026', style: _cap),
                      ]),
                      const CircleIconButton(icon: Icons.download_outlined),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Period chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(children: [
                      TypeChip(label: 'Tháng này'),
                      const SizedBox(width: 8),
                      TypeChip(label: 'Quý này'),
                      const SizedBox(width: 8),
                      TypeChip(label: 'Năm 2026', active: true),
                      const SizedBox(width: 8),
                      TypeChip(label: 'Năm 2025'),
                    ]),
                  ),
                ],
              ),
            ),
          ),

          // Hero KPI
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: _HeroKpiCard(),
            ),
          ),

          // 2×2 KPI grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _BigKpi(label: 'Tổng tín đồ', value: '8.420', unit: 'người', delta: '↑ +124', tone: _KpiTone.ok),
                  _BigKpi(label: 'Chức sắc', value: '68', unit: 'người', delta: '— 0', tone: _KpiTone.neutral),
                  _BigKpi(label: 'Lễ hội 2026', value: '12', unit: 'lễ hội', delta: '↓ -2', tone: _KpiTone.warn),
                  _BigKpi(label: 'Diện tích đất', value: '18.420', unit: 'm²', delta: '↑ +340', tone: _KpiTone.ok),
                ],
              ),
            ),
          ),

          // Donut chart
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _LegalStatusCard(),
            ),
          ),

          // Area chart
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _TrendCard(),
            ),
          ),

          // Recent activity
          SliverToBoxAdapter(child: _ActivitySection()),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ─── Hero KPI ──────────────────────────────────────────────────

class _HeroKpiCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          Text('CƠ SỞ TÔN GIÁO', style: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w500,
            color: AppColors.inkSoft, letterSpacing: 0.05,
          )),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('48', style: GoogleFonts.inter(
                fontSize: 48, fontWeight: FontWeight.w700,
                color: AppColors.ink, letterSpacing: -0.03, height: 1,
              )),
              const SizedBox(width: 8),
              Text('cơ sở', style: GoogleFonts.inter(fontSize: 13, color: AppColors.inkSoft)),
              const Spacer(),
              const StatusPill(kind: PillKind.emerald, label: '↑ +2', fontSize: 11),
            ],
          ),
          const SizedBox(height: 18),
          _ReligionBar(label: 'Phật giáo', count: 22, max: 48, color: AppColors.buddhism),
          const SizedBox(height: 8),
          _ReligionBar(label: 'Công giáo', count: 11, max: 48, color: AppColors.catholic),
          const SizedBox(height: 8),
          _ReligionBar(label: 'Cao Đài', count: 6, max: 48, color: AppColors.caodai),
          const SizedBox(height: 8),
          _ReligionBar(label: 'Tin Lành', count: 4, max: 48, color: AppColors.protestant),
          const SizedBox(height: 8),
          _ReligionBar(label: 'Khác', count: 5, max: 48, color: AppColors.folk),
        ],
      ),
    );
  }
}

class _ReligionBar extends StatelessWidget {
  final String label;
  final int count, max;
  final Color color;
  const _ReligionBar({required this.label, required this.count, required this.max, required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = count / max;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.inkMuted)),
            Text('$count', style: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink,
            )),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: AppColors.parchment2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ─── 2×2 KPI Tiles ─────────────────────────────────────────────

enum _KpiTone { ok, warn, neutral }

class _BigKpi extends StatelessWidget {
  final String label, value, unit, delta;
  final _KpiTone tone;
  const _BigKpi({required this.label, required this.value, required this.unit,
      required this.delta, required this.tone});

  Color get _deltaColor => switch (tone) {
    _KpiTone.ok      => AppColors.emeraldFg,
    _KpiTone.warn    => AppColors.amberFg,
    _KpiTone.neutral => AppColors.inkSoft,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.w500,
            color: AppColors.inkSoft, letterSpacing: 0.04,
          )),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: GoogleFonts.inter(
                fontSize: 24, fontWeight: FontWeight.w700,
                color: AppColors.ink, letterSpacing: -0.02, height: 1.05,
              )),
              const SizedBox(width: 4),
              Text(unit, style: GoogleFonts.inter(fontSize: 10, color: AppColors.inkSoft)),
            ],
          ),
          const SizedBox(height: 6),
          Text(delta, style: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w700, color: _deltaColor,
          )),
        ],
      ),
    );
  }
}

// ─── Donut Chart ───────────────────────────────────────────────

class _LegalStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const segments = [
      _DonutSegment(value: 38, color: Color(0xFF2A8A5A)),
      _DonutSegment(value: 6,  color: Color(0xFFB8870C)),
      _DonutSegment(value: 3,  color: AppColors.inkSoft),
      _DonutSegment(value: 1,  color: Color(0xFFB03328)),
    ];
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
          Text('Tình trạng pháp lý', style: GoogleFonts.inter(
            fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.ink, letterSpacing: -0.01,
          )),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 100, height: 100,
                child: CustomPaint(
                  painter: _DonutPainter(segments: segments, total: 48),
                  child: Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('48', style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.w700,
                        color: AppColors.ink, letterSpacing: -0.03, height: 1,
                      )),
                      Text('CƠ SỞ', style: GoogleFonts.inter(
                        fontSize: 8, color: AppColors.inkSoft, letterSpacing: 0.08,
                      )),
                    ],
                  )),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(child: Column(
                children: const [
                  _LegendRow(color: Color(0xFF2A8A5A), label: 'Đã công nhận', value: '38'),
                  SizedBox(height: 8),
                  _LegendRow(color: Color(0xFFB8870C), label: 'Đang xét duyệt', value: '6'),
                  SizedBox(height: 8),
                  _LegendRow(color: AppColors.inkSoft, label: 'Chưa đăng ký', value: '3'),
                  SizedBox(height: 8),
                  _LegendRow(color: Color(0xFFB03328), label: 'Đình chỉ', value: '1'),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutSegment {
  final double value;
  final Color color;
  const _DonutSegment({required this.value, required this.color});
}

class _DonutPainter extends CustomPainter {
  final List<_DonutSegment> segments;
  final double total;
  const _DonutPainter({required this.segments, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 8;
    const strokeWidth = 14.0;
    const gap = 0.04;

    final bgPaint = Paint()
      ..color = AppColors.hairline
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    double start = -math.pi / 2;
    for (final seg in segments) {
      final sweep = (seg.value / total) * 2 * math.pi - gap;
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start, sweep, false, paint,
      );
      start += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label, value;
  const _LegendRow({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 9, height: 9,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.inkMuted))),
      Text(value, style: GoogleFonts.inter(
        fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink,
      )),
    ]);
  }
}

// ─── Area / Trend Chart ────────────────────────────────────────

class _TrendCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Xu hướng tín đồ', style: GoogleFonts.inter(
                fontSize: 17, fontWeight: FontWeight.w600,
                color: AppColors.ink, letterSpacing: -0.01,
              )),
              Text('T1/25 → T5/26', style: GoogleFonts.inter(fontSize: 13, color: AppColors.inkSoft)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 128,
            child: CustomPaint(
              painter: _AreaChartPainter(),
              size: const Size(double.infinity, 110),
            ),
          ),
        ],
      ),
    );
  }
}

class _AreaChartPainter extends CustomPainter {
  static const pts = [
    8120.0, 8160, 8200, 8190, 8240, 8280, 8310,
    8290, 8340, 8360, 8380, 8400, 8420, 8410, 8420, 8420, 8420,
  ];
  static const _min = 8000.0;
  static const _max = 8500.0;
  static const _labelH = 18.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartH = size.height - _labelH;
    final w = size.width;
    final xStep = w / (pts.length - 1);

    Offset toOffset(int i) {
      final x = i * xStep;
      final y = chartH - ((pts[i] - _min) / (_max - _min)) * chartH;
      return Offset(x, y);
    }

    // Build line path
    final linePath = Path();
    linePath.moveTo(0, toOffset(0).dy);
    for (int i = 1; i < pts.length; i++) {
      linePath.lineTo(toOffset(i).dx, toOffset(i).dy);
    }

    // Area fill
    final areaPath = Path.from(linePath)
      ..lineTo(w, chartH)
      ..lineTo(0, chartH)
      ..close();

    final gradientRect = Rect.fromLTWH(0, 0, w, chartH);
    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.primary.withValues(alpha: 0.25), AppColors.primary.withValues(alpha: 0.02)],
      ).createShader(gradientRect);
    canvas.drawPath(areaPath, areaPaint);

    // Line stroke
    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // End dot
    final last = toOffset(pts.length - 1);
    canvas.drawCircle(last, 4, Paint()..color = AppColors.primary);
    canvas.drawCircle(last, 4, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);

    // Axis labels
    final textStyle = TextStyle(
      fontSize: 9, color: AppColors.inkFaint,
      fontFamily: GoogleFonts.inter().fontFamily,
    );
    _drawText(canvas, 'T1/25', Offset(0, chartH + 4), textStyle, TextAlign.left);
    _drawText(canvas, 'T5/26', Offset(w, chartH + 4), textStyle, TextAlign.right);
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style, TextAlign align) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout();
    final dx = align == TextAlign.right ? offset.dx - tp.width : offset.dx;
    tp.paint(canvas, Offset(dx, offset.dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Activity Section ──────────────────────────────────────────

class _ActivitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hoạt động gần đây', style: GoogleFonts.inter(
                  fontSize: 19, fontWeight: FontWeight.w600, color: AppColors.ink, letterSpacing: -0.015,
                )),
                Text('Xem hết', style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary,
                )),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.canvas,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [AppColors.cardShadow],
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(children: [
                _ActivityRow(kind: PillKind.emerald, tag: 'Thêm mới', entity: 'Cơ sở',
                    name: 'Tịnh xá Ngọc Phương', time: '2 giờ trước'),
                Divider(color: AppColors.hairline, height: 1, thickness: 1),
                _ActivityRow(kind: PillKind.blue, tag: 'Cập nhật', entity: 'Sửa chữa',
                    name: 'Chùa Pháp Hoa · trùng tu mái', time: '5 giờ trước'),
                Divider(color: AppColors.hairline, height: 1, thickness: 1),
                _ActivityRow(kind: PillKind.amber, tag: 'Cấp phép', entity: 'Sự kiện',
                    name: 'Lễ Hiệp Thông · GP-021/2026', time: 'hôm qua'),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final PillKind kind;
  final String tag, entity, name, time;
  const _ActivityRow({required this.kind, required this.tag,
      required this.entity, required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        StatusPill(kind: kind, label: tag, fontSize: 10.5),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: GoogleFonts.inter(
              fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.ink,
            )),
            Text('$entity · $time', style: GoogleFonts.inter(
              fontSize: 11, color: AppColors.inkSoft,
            )),
          ],
        )),
      ]),
    );
  }
}

final _hero = AppTextStyles.hero;
final _cap = AppTextStyles.cap;
