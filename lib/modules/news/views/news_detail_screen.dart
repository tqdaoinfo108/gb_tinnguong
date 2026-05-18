import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../../../data/models/news_model.dart';
import '../../../widgets/circle_icon_button.dart';
import '../../../widgets/img_placeholder.dart';
import '../../../widgets/network_img.dart';
import '../../../widgets/status_pill.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;
  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final top    = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final body   = _stripHtml(news.description ?? '');
    final readMin = _readingMinutes(body);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Sticky nav ──────────────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _NavDelegate(
              top: top,
              onBack: () => Navigator.pop(context),
            ),
          ),

          // ── Hero image ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: NetworkImg(
              imagePath: news.imagePath,
              width: double.infinity,
              height: 240,
              fallbackVariant: ImgVariant.warm,
              fallbackTag: news.title.toLowerCase(),
            ),
          ),

          // ── Meta: pill + date + reading time ───────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  const StatusPill(kind: PillKind.emerald, label: 'Tin tức'),
                  const SizedBox(width: 10),
                  Text(_fmtDate(news.datePublish), style: _metaStyle),
                  if (readMin > 0) ...[
                    _dot,
                    Text('$readMin phút đọc', style: _metaStyle),
                  ],
                ],
              ),
            ),
          ),

          // ── Title ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Text(
                news.title,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.02,
                  height: 1.22,
                ),
              ),
            ),
          ),

          // ── Divider ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Divider(color: AppColors.hairline, height: 1),
            ),
          ),

          // ── Body ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: body.isEmpty
                  ? Text(
                      'Không có nội dung.',
                      style: GoogleFonts.inter(
                        fontSize: 16, height: 1.7, color: AppColors.inkSoft,
                      ),
                    )
                  : _HtmlBody(raw: news.description ?? ''),
            ),
          ),

          // ── Bottom padding ──────────────────────────────────────
          SliverToBoxAdapter(child: SizedBox(height: bottom + 60)),
        ],
      ),
    );
  }
}

// ── HTML body renderer (paragraphs, bold, italic, lists) ─────────────────────

class _HtmlBody extends StatelessWidget {
  final String raw;
  const _HtmlBody({required this.raw});

  @override
  Widget build(BuildContext context) {
    // Split by block-level tags into paragraphs
    final paragraphs = _splitParagraphs(raw);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.asMap().entries.map((e) {
        final text = e.value.trim();
        if (text.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.only(bottom: e.key < paragraphs.length - 1 ? 14 : 0),
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 16,
              height: 1.7,
              color: AppColors.inkMuted,
            ),
          ),
        );
      }).toList(),
    );
  }
}

List<String> _splitParagraphs(String html) {
  // Replace block-level close tags with newlines, then strip remaining tags
  var s = html
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

// ── Utils ─────────────────────────────────────────────────────────────────────

String _stripHtml(String html) =>
    html.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ').trim();

int _readingMinutes(String text) {
  final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  return (words / 200).ceil();
}

String _fmtDate(DateTime? dt) {
  if (dt == null) return '';
  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  return '$d/$m/${dt.year}';
}

final _metaStyle = GoogleFonts.inter(
  fontSize: 13, color: AppColors.inkSoft, fontWeight: FontWeight.w500,
);
const _dot = Padding(
  padding: EdgeInsets.symmetric(horizontal: 6),
  child: Text('·', style: TextStyle(color: AppColors.inkFaint)),
);

// ── Sticky nav delegate ───────────────────────────────────────────────────────

class _NavDelegate extends SliverPersistentHeaderDelegate {
  final double top;
  final VoidCallback onBack;
  const _NavDelegate({required this.top, required this.onBack});

  double get _h => top + 60;

  @override double get minExtent => _h;
  @override double get maxExtent => _h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final blur = (shrinkOffset / _h).clamp(0.0, 1.0);
    return Container(
      color: AppColors.parchment.withValues(alpha: 0.94 + blur * 0.06),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, top + 12, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back
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
            // Actions
            Row(children: [
              CircleIconButton(
                icon: Icons.ios_share_rounded,
                onTap: () {},
              ),
            ]),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_NavDelegate old) => old.top != top;
}
