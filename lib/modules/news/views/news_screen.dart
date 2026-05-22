import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../data/models/news_model.dart';
import '../../../widgets/img_placeholder.dart';
import '../../../widgets/network_img.dart';
import '../../../widgets/status_pill.dart';
import '../controllers/news_controller.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NewsController>();
    final top  = MediaQuery.of(context).padding.top;
    final bot  = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: Column(
        children: [

          // ── Cố định: title + search ──────────────────────────
          Container(
            color: AppColors.parchment,
            padding: EdgeInsets.fromLTRB(20, top + 16, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tin tức', style: _hero),
                Text('Hoạt động & sự kiện Phường 5', style: _cap),
                const SizedBox(height: 14),
                _SearchBar(ctrl: ctrl),
              ],
            ),
          ),

          // ── Divider mỏng ──────────────────────────────────────
          const Divider(height: 1, color: AppColors.hairline),

          // ── Scrollable list ───────────────────────────────────
          Expanded(
            child: Obx(() {
              final items = ctrl.news;

              if (ctrl.isLoading.value && items.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary, strokeWidth: 2,
                  ),
                );
              }

              if (items.isEmpty) {
                return Center(
                  child: Text('Chưa có tin tức', style: _cap),
                );
              }

              final featured = items.first;
              final rest = items.length > 1 ? items.sublist(1) : <NewsModel>[];

              return ListView(
                padding: EdgeInsets.fromLTRB(20, 16, 20, bot + 100),
                physics: const BouncingScrollPhysics(),
                children: [

                  // ── Featured card ───────────────────────────
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NewsDetailScreen(news: featured),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.canvas,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [AppColors.cardShadow],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NetworkImg(
                            imagePath: featured.imagePath,
                            width: double.infinity,
                            height: 200,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(19),
                            ),
                            fallbackTag: featured.title.toLowerCase(),
                            fallbackVariant: ImgVariant.warm,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  const StatusPill(
                                    kind: PillKind.emerald, label: 'Tin tức',
                                  ),
                                  const SizedBox(width: 8),
                                  Text(_fmtDate(featured.datePublish), style: _cap),
                                ]),
                                const SizedBox(height: 8),
                                Text(featured.title, style: _h2),
                                if (featured.description != null &&
                                    featured.description!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    featured.description!
                                        .replaceAll(RegExp(r'<[^>]*>'), ''),
                                    style: _bodyMuted,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── News list ───────────────────────────────
                  if (rest.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    ...rest.asMap().entries.map((e) => Padding(
                      padding: EdgeInsets.only(
                        bottom: e.key < rest.length - 1 ? 14 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => NewsDetailScreen(news: e.value),
                          ),
                        ),
                        child: _NewsItem.fromModel(e.value, index: e.key),
                      ),
                    )),
                  ],

                  // ── Load more ───────────────────────────────
                  if (ctrl.hasMore.value) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: ctrl.isLoading.value ? null : ctrl.loadMore,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(
                              color: AppColors.primary.withValues(alpha: 0.4)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: ctrl.isLoading.value
                            ? const SizedBox(
                                width: 18, height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppColors.primary,
                                ),
                              )
                            : const Text('Tải thêm'),
                      ),
                    ),
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final NewsController ctrl;
  const _SearchBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (v) => ctrl.searchKey.value = v,
      style: GoogleFonts.inter(fontSize: 14, color: AppColors.ink),
      decoration: InputDecoration(
        hintText: 'Tìm kiếm tin tức…',
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.inkFaint),
        prefixIcon: const Icon(
          Icons.search_rounded, size: 20, color: AppColors.inkFaint,
        ),
        suffixIcon: Obx(() => ctrl.searchKey.value.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded,
                    size: 18, color: AppColors.inkFaint),
                onPressed: () {
                  ctrl.searchKey.value = '';
                  FocusScope.of(context).unfocus();
                },
              )
            : const SizedBox.shrink()),
        filled: true,
        fillColor: AppColors.canvas,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

// ── News row item ─────────────────────────────────────────────────────────────

class _NewsItem extends StatelessWidget {
  final String title;
  final String excerpt;
  final String date;
  final String? imagePath;
  final ImgVariant fallbackVariant;

  const _NewsItem({
    required this.title,
    required this.excerpt,
    required this.date,
    this.imagePath,
    required this.fallbackVariant,
  });

  factory _NewsItem.fromModel(NewsModel m, {required int index}) {
    const variants = ImgVariant.values;
    return _NewsItem(
      title: m.title,
      excerpt: (m.description ?? '').replaceAll(RegExp(r'<[^>]*>'), ''),
      date: _fmtDate(m.datePublish),
      imagePath: m.imagePath,
      fallbackVariant: variants[index % variants.length],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [AppColors.lightShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkImg(
              imagePath: imagePath,
              width: 90,
              height: 90,
              borderRadius: BorderRadius.circular(10),
              fallbackTag: title,
              fallbackVariant: fallbackVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusPill(
                      kind: PillKind.blue, label: 'Tin tức', fontSize: 10.5),
                  const SizedBox(height: 6),
                  Text(title, style: _bodyStrong,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(excerpt, style: _cap,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(date, style: GoogleFonts.inter(
                    fontSize: 11, fontWeight: FontWeight.w500,
                    color: AppColors.inkFaint,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Utils ─────────────────────────────────────────────────────────────────────

String _fmtDate(DateTime? dt) {
  if (dt == null) return '—';
  return '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

// ── Text styles ───────────────────────────────────────────────────────────────

final _hero = AppTextStyles.hero;
final _h2 = GoogleFonts.inter(
  fontSize: 19,
  fontWeight: FontWeight.w600,
  color: AppColors.ink,
  letterSpacing: -0.015,
);
final _bodyStrong = AppTextStyles.bodyStrong;
final _bodyMuted  = GoogleFonts.inter(
  fontSize: 15, height: 1.45, color: AppColors.inkMuted,
);
final _cap = AppTextStyles.cap;
