import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../data/models/news_model.dart';
import '../../../widgets/circle_icon_button.dart';
import '../../../widgets/filter_chip.dart';
import '../../../widgets/img_placeholder.dart';
import '../../../widgets/status_pill.dart';
import '../controllers/news_controller.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewsController());
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Tin tức', style: _hero),
                    Text('Hoạt động & sự kiện Phường 5', style: _cap),
                  ]),
                  const CircleIconButton(icon: Icons.search_rounded),
                ],
              ),
            ),
          ),

          // Filter chips
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 16),
              child: FilterChipBar(
                labels: ['Tất cả', 'Công nhận', 'Hoạt động', 'Thông báo', 'Sự kiện'],
              ),
            ),
          ),

          // Content
          Obx(() {
            if (controller.isLoading.value && controller.news.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
                ),
              );
            }

            if (controller.news.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                  child: Center(child: Text('Chưa có tin tức', style: _cap)),
                ),
              );
            }

            final featured = controller.news.first;
            final rest = controller.news.length > 1 ? controller.news.sublist(1) : <NewsModel>[];

            return SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured card
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NewsDetailScreen()),
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
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                              child: ImgPlaceholder(
                                width: double.infinity, height: 200,
                                tag: featured.title.toLowerCase(),
                                variant: ImgVariant.warm,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    const StatusPill(kind: PillKind.emerald, label: 'Tin tức'),
                                    const SizedBox(width: 8),
                                    Text(_formatDate(featured.datePublish), style: _cap),
                                  ]),
                                  const SizedBox(height: 8),
                                  Text(featured.title, style: _h2),
                                  if (featured.description != null && featured.description!.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      featured.description!.replaceAll(RegExp(r'<[^>]*>'), ''),
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
                  ),

                  // News list
                  if (rest.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        children: rest.asMap().entries.map((e) => Padding(
                          padding: EdgeInsets.only(bottom: e.key < rest.length - 1 ? 14 : 0),
                          child: _NewsItem.fromModel(e.value, index: e.key),
                        )).toList(),
                      ),
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

String _formatDate(DateTime? dt) {
  if (dt == null) return '—';
  return DateFormat('dd/MM/yyyy').format(dt);
}

class _NewsItem extends StatelessWidget {
  final String tag;
  final PillKind kind;
  final String title;
  final String excerpt;
  final String date;
  final ImgVariant variant;
  const _NewsItem({
    required this.tag, required this.kind,
    required this.title, required this.excerpt,
    required this.date, required this.variant,
  });

  factory _NewsItem.fromModel(NewsModel m, {required int index}) {
    const variants = ImgVariant.values;
    return _NewsItem(
      tag: 'tin tức',
      kind: PillKind.blue,
      title: m.title,
      excerpt: (m.description ?? '').replaceAll(RegExp(r'<[^>]*>'), ''),
      date: _formatDate(m.datePublish),
      variant: variants[index % variants.length],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImgPlaceholder(
          width: 110, height: 110, tag: tag,
          variant: variant, borderRadius: BorderRadius.circular(14),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusPill(kind: kind, label: tag, fontSize: 10.5),
            const SizedBox(height: 6),
            Text(title, style: _bodyStrong, maxLines: 2),
            const SizedBox(height: 4),
            Text(excerpt, style: _cap, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Text(date, style: GoogleFonts.inter(
              fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.inkFaint,
            )),
          ],
        )),
      ],
    );
  }
}

final _hero = AppTextStyles.hero;
final _h2 = GoogleFonts.inter(
  fontSize: 19, fontWeight: FontWeight.w600,
  color: AppColors.ink, letterSpacing: -0.015,
);
final _bodyStrong = AppTextStyles.bodyStrong;
final _bodyMuted = GoogleFonts.inter(
  fontSize: 15, height: 1.45, color: AppColors.inkMuted,
);
final _cap = AppTextStyles.cap;
