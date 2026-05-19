import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/religion_palette.dart' as palette;
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../data/models/event_model.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final top    = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final color  = palette.religionColor(event.religionName);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.parchment,
        // Stack: scrollable content + fixed nav overlay on top
        body: Stack(
          children: [

            // ── Scrollable body ───────────────────────────────────────
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [

                // ── Hero ────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Gradient background
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                color.withValues(alpha: 0.92),
                                Color.lerp(color, AppColors.ink, 0.45)!,
                              ],
                            ),
                          ),
                        ),
                        // Dot texture
                        Positioned.fill(
                          child: CustomPaint(painter: _DotPatternPainter()),
                        ),
                        // Dark gradient top + bottom
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x601E2D3D),
                                Colors.transparent,
                                Colors.transparent,
                                Color(0xD81E2D3D),
                              ],
                              stops: [0, 0.3, 0.5, 1],
                            ),
                          ),
                        ),
                        // Title block — well above the card
                        Positioned(
                          left: 20, right: 20, bottom: 28,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _StatusHeroPill(statusID: event.statusID),
                              const SizedBox(height: 10),
                              Text(
                                event.eventName,
                                style: GoogleFonts.inter(
                                  fontSize: 24, fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.02, height: 1.2,
                                ),
                              ),
                              if (event.typeEventName != null) ...[
                                const SizedBox(height: 5),
                                Text(
                                  event.typeEventName!,
                                  style: GoogleFonts.inter(
                                    fontSize: 14, fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.82),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Quick-facts card ───────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.hairline),
                        boxShadow: [AppColors.cardShadow],
                      ),
                      child: Column(
                        children: [
                          // Date
                          _FactRow(
                            icon: Icons.calendar_month_rounded,
                            label: 'Thời gian',
                            value: _fmtDateRange(event.dateStart, event.dateEnd),
                          ),
                          if (event.officeName != null) ...[
                            const Divider(color: AppColors.hairline, height: 24),
                            _FactRow(
                              icon: Icons.location_on_outlined,
                              label: 'Địa điểm',
                              value: event.officeName!,
                            ),
                          ],
                          if (event.villageName != null) ...[
                            const Divider(color: AppColors.hairline, height: 24),
                            _FactRow(
                              icon: Icons.place_outlined,
                              label: 'Khu phố',
                              value: event.villageName!,
                            ),
                          ],
                          if (event.personJoin != null) ...[
                            const Divider(color: AppColors.hairline, height: 24),
                            _FactRow(
                              icon: Icons.people_outline_rounded,
                              label: 'Tham dự dự kiến',
                              value: '~ ${_fmtNum(event.personJoin!)} người',
                            ),
                          ],
                          const Divider(color: AppColors.hairline, height: 24),
                          _PermitFactRow(
                            hasPermit: event.hasPermit == true,
                            permitNo: event.permitNo,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Meta chips ────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _MetaChips(event: event),
                  ),
                ),

                // ── Description ───────────────────────────────────
                if (event.description != null &&
                    event.description!.trim().isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nội dung sự kiện', style: _h2),
                          const SizedBox(height: 10),
                          ..._renderDescription(event.description!),
                        ],
                      ),
                    ),
                  ),

                // ── Organizer ─────────────────────────────────────
                if (event.officeName != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Đơn vị tổ chức', style: _h2),
                          const SizedBox(height: 12),
                          _OrganizerCard(event: event),
                        ],
                      ),
                    ),
                  ),

                // Bottom spacer
                SliverToBoxAdapter(child: SizedBox(height: bottom + 48)),
              ],
            ),

            // ── Fixed nav overlay (does NOT scroll) ──────────────────
            Positioned(
              left: 16, right: 16, top: top + 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavBtn(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  _NavBtn(
                    icon: Icons.ios_share_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status pill in hero ───────────────────────────────────────────────────────

class _StatusHeroPill extends StatelessWidget {
  final int? statusID;
  const _StatusHeroPill({this.statusID});

  @override
  Widget build(BuildContext context) {
    final (dotColor, label) = switch (statusID) {
      1 => (const Color(0xFF6EA8D6), 'Sắp diễn ra'),
      2 => (const Color(0xFFFFC947), 'Đang diễn ra'),
      3 => (const Color(0xFF5EC48A), 'Hoàn thành'),
      4 => (const Color(0xFFFF7B72), 'Đã hủy'),
      _ => (Colors.white54,          'Không xác định'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 6, height: 6,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white,
        )),
      ]),
    );
  }
}

// ── Fact row ─────────────────────────────────────────────────────────────────

class _FactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool emerald;
  const _FactRow({
    required this.icon, required this.label, required this.value,
    this.emerald = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: AppColors.parchment,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 17, color: AppColors.inkMuted),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.w500,
            color: AppColors.inkSoft, letterSpacing: 0.06,
          )),
          const SizedBox(height: 2),
          Text(value, style: GoogleFonts.inter(
            fontSize: 15, fontWeight: FontWeight.w600,
            color: emerald ? AppColors.emeraldFg : AppColors.ink,
          )),
        ],
      )),
    ]);
  }
}

class _PermitFactRow extends StatelessWidget {
  final bool hasPermit;
  final String? permitNo;
  const _PermitFactRow({required this.hasPermit, this.permitNo});

  @override
  Widget build(BuildContext context) {
    final fg    = hasPermit ? AppColors.emeraldFg : AppColors.amberFg;
    final icon  = hasPermit ? Icons.verified_rounded : Icons.warning_amber_rounded;
    final value = hasPermit
        ? (permitNo != null ? 'Đã cấp · $permitNo' : 'Đã cấp phép')
        : 'Chưa có giấy phép';

    return Row(children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: hasPermit ? AppColors.emeraldBg : AppColors.amberBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 17, color: fg),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('GIẤY PHÉP', style: GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.w500,
            color: AppColors.inkSoft, letterSpacing: 0.06,
          )),
          const SizedBox(height: 2),
          Text(value, style: GoogleFonts.inter(
            fontSize: 15, fontWeight: FontWeight.w600, color: fg,
          )),
        ],
      )),
    ]);
  }
}

// ── Meta chips ────────────────────────────────────────────────────────────────

class _MetaChips extends StatelessWidget {
  final EventModel event;
  const _MetaChips({required this.event});

  @override
  Widget build(BuildContext context) {
    final chips = <(Color bg, Color fg, String label)>[];

    if (event.religionName != null) {
      final c = palette.religionColor(event.religionName);
      chips.add((c.withValues(alpha: 0.12), c, event.religionName!));
    }
    if (event.typeEventName != null) {
      chips.add((AppColors.blueBg, AppColors.blueFg, event.typeEventName!));
    }
    if (event.isActivity == true) {
      chips.add((AppColors.emeraldBg, AppColors.emeraldDot, 'Đang hoạt động'));
    }
    if (event.codeActivity != null && event.codeActivity!.isNotEmpty) {
      chips.add((AppColors.parchment2, AppColors.inkMuted, event.codeActivity!));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips.map((c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: c.$1,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: c.$2.withValues(alpha: 0.2)),
        ),
        child: Text(c.$3, style: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w600, color: c.$2,
        )),
      )).toList(),
    );
  }
}

// ── Organizer card ────────────────────────────────────────────────────────────

class _OrganizerCard extends StatelessWidget {
  final EventModel event;
  const _OrganizerCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final color = palette.religionColor(event.religionName);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [AppColors.lightShadow],
      ),
      child: Row(children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Center(
            child: Container(
              width: 18, height: 18,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.officeName!, style: GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink,
            )),
            if (event.religionName != null || event.villageName != null)
              Text(
                [
                  if (event.religionName != null) event.religionName!,
                  if (event.villageName != null) event.villageName!,
                ].join(' · '),
                style: AppTextStyles.cap,
              ),
          ],
        )),
        const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.inkFaint),
      ]),
    );
  }
}

// ── Fixed nav button ──────────────────────────────────────────────────────────

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.hairline),
          boxShadow: [BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8, offset: const Offset(0, 2),
          )],
        ),
        child: Icon(icon, size: 18, color: AppColors.ink),
      ),
    );
  }
}

// ── Dot pattern painter ───────────────────────────────────────────────────────

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.fill;
    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPatternPainter _) => false;
}

// ── Helpers ───────────────────────────────────────────────────────────────────

List<Widget> _renderDescription(String raw) {
  final stripped = raw
      .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</li>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll(RegExp(r'&nbsp;'), ' ')
      .replaceAll(RegExp(r'&amp;'), '&')
      .replaceAll(RegExp(r'&lt;'), '<')
      .replaceAll(RegExp(r'&gt;'), '>')
      .replaceAll(RegExp(r'&quot;'), '"');

  final paragraphs = stripped
      .split('\n')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  if (paragraphs.isEmpty) return [];

  return [
    for (int i = 0; i < paragraphs.length; i++) ...[
      if (i > 0) const SizedBox(height: 10),
      Text(paragraphs[i], style: GoogleFonts.inter(
        fontSize: 15, height: 1.6, color: AppColors.inkMuted,
      )),
    ],
  ];
}

String _fmtDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  return '$dd/$mm/${d.year}';
}

String _fmtDateRange(DateTime? start, DateTime? end) {
  if (start == null && end == null) return '—';
  if (start == null) return _fmtDate(end!);
  if (end == null)   return _fmtDate(start);
  if (start.year == end.year &&
      start.month == end.month &&
      start.day == end.day) {
    return _fmtDate(start);
  }
  // Compact form only when same month AND chronological
  if (start.year == end.year &&
      start.month == end.month &&
      !start.isAfter(end)) {
    final mm = start.month.toString().padLeft(2, '0');
    return '${start.day} – ${end.day} / $mm / ${start.year}';
  }
  return '${_fmtDate(start)} – ${_fmtDate(end)}';
}

String _fmtNum(int n) {
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
  return '$n';
}

final _h2 = GoogleFonts.inter(
  fontSize: 19, fontWeight: FontWeight.w600,
  color: AppColors.ink, letterSpacing: -0.015,
);
