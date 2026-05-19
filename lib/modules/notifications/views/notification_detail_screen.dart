import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../../../data/models/information_model.dart';

class NotificationDetailScreen extends StatelessWidget {
  final InformationModel notification;
  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final top    = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final kind   = _kindFromLevel(notification.levelID);
    final (bg, fg, icon, label) = _attrs(kind);
    final body = _stripHtml(notification.description ?? '');

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Top bar ─────────────────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _NavDelegate(top: top, onBack: () => Navigator.pop(context)),
          ),

          // ── Coloured icon header ─────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: bg,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: fg.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, size: 26, color: fg),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Chip(label: label, fg: fg, bg: fg.withValues(alpha: 0.12)),
                        const SizedBox(height: 10),
                        Text(
                          notification.title,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            height: 1.25,
                            letterSpacing: -0.015,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Meta row ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  if (notification.dateCreate != null)
                    _MetaItem(
                      icon: Icons.schedule_rounded,
                      text: _fmtDateFull(notification.dateCreate!),
                    ),
                  if (notification.senderName != null)
                    _MetaItem(
                      icon: Icons.person_outline_rounded,
                      text: notification.senderName!,
                    ),
                  if (notification.senderRole != null)
                    _MetaItem(
                      icon: Icons.badge_outlined,
                      text: notification.senderRole!,
                    ),
                ],
              ),
            ),
          ),

          // ── Divider ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Divider(color: AppColors.hairline, height: 1),
            ),
          ),

          // ── Short description (if exists and body is different) ──
          if (notification.shortDescription != null &&
              notification.shortDescription!.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: fg.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Text(
                    notification.shortDescription!,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      height: 1.55,
                      color: AppColors.ink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

          // ── Full body ────────────────────────────────────────────
          if (body.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _BodyText(raw: notification.description!),
              ),
            ),

          if (body.isEmpty && (notification.shortDescription == null ||
              notification.shortDescription!.isEmpty))
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Text(
                  'Không có nội dung chi tiết.',
                  style: GoogleFonts.inter(
                    fontSize: 15, color: AppColors.inkFaint,
                  ),
                ),
              ),
            ),

          SliverToBoxAdapter(child: SizedBox(height: bottom + 60)),
        ],
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _BodyText extends StatelessWidget {
  final String raw;
  const _BodyText({required this.raw});

  @override
  Widget build(BuildContext context) {
    final paras = _splitParagraphs(raw);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paras.asMap().entries.map((e) {
        final t = e.value.trim();
        if (t.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.only(bottom: e.key < paras.length - 1 ? 14 : 0),
          child: Text(
            t,
            style: GoogleFonts.inter(
              fontSize: 16, height: 1.7, color: AppColors.inkMuted,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Meta item ─────────────────────────────────────────────────────────────────

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: AppColors.inkFaint),
      const SizedBox(width: 5),
      Text(text, style: GoogleFonts.inter(
        fontSize: 13, color: AppColors.inkSoft, fontWeight: FontWeight.w500,
      )),
    ],
  );
}

// ── Chip ──────────────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final Color fg;
  final Color bg;
  const _Chip({required this.label, required this.fg, required this.bg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(label, style: GoogleFonts.inter(
      fontSize: 12, fontWeight: FontWeight.w600, color: fg,
    )),
  );
}

// ── Sticky nav ────────────────────────────────────────────────────────────────

class _NavDelegate extends SliverPersistentHeaderDelegate {
  final double top;
  final VoidCallback onBack;
  const _NavDelegate({required this.top, required this.onBack});

  double get _h => top + 60;
  @override double get minExtent => _h;
  @override double get maxExtent => _h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
        color: AppColors.parchment.withValues(alpha: 0.96),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, top + 12, 16, 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.hairline),
                    boxShadow: [AppColors.lightShadow],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 15, color: AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Chi tiết thông báo',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  bool shouldRebuild(_NavDelegate old) => old.top != top;
}

// ── Helpers ───────────────────────────────────────────────────────────────────

// 1 = Khẩn cấp  2 = Thông thường  3 = Thấp
enum _Kind { urgent, normal, low, system }

_Kind _kindFromLevel(int? level) => switch (level) {
  1 => _Kind.urgent,
  2 => _Kind.normal,
  3 => _Kind.low,
  _ => _Kind.system,
};

(Color bg, Color fg, IconData icon, String label) _attrs(_Kind kind) =>
    switch (kind) {
      _Kind.urgent => (AppColors.redBg,      AppColors.redFg,    Icons.warning_rounded,             'Khẩn cấp'),
      _Kind.normal => (AppColors.blueBg,     AppColors.primary,  Icons.notifications_outlined,      'Thông thường'),
      _Kind.low    => (AppColors.slateBg,    AppColors.inkMuted, Icons.info_outline_rounded,        'Thấp'),
      _Kind.system => (AppColors.parchment2, AppColors.inkFaint, Icons.settings_outlined,           'Hệ thống'),
    };

String _stripHtml(String html) =>
    html.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ').trim();

List<String> _splitParagraphs(String html) {
  final s = html
      .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</li>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"');
  return s.split('\n').where((p) => p.trim().isNotEmpty).toList();
}

String _fmtDateFull(DateTime dt) {
  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final h = dt.hour.toString().padLeft(2, '0');
  final min = dt.minute.toString().padLeft(2, '0');
  return '$h:$min  $d/$m/${dt.year}';
}
