import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../../../widgets/circle_icon_button.dart';
import '../../../widgets/img_placeholder.dart';
import '../../../widgets/status_pill.dart';

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Sticky top nav
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyNavDelegate(top: top, onBack: () => Navigator.pop(context)),
          ),

          // Category + Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusPill(kind: PillKind.emerald, label: 'Công nhận'),
                  const SizedBox(height: 12),
                  Text(
                    'Trao quyết định công nhận Tịnh xá Ngọc Phương là cơ sở tôn giáo',
                    style: GoogleFonts.inter(
                      fontSize: 24, fontWeight: FontWeight.w700,
                      color: AppColors.ink, letterSpacing: -0.02, height: 1.18,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(children: [
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.parchment2, shape: BoxShape.circle,
                      ),
                      child: Center(child: Text('BT', style: GoogleFonts.inter(
                        fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.ink,
                      ))),
                    ),
                    const SizedBox(width: 6),
                    Text('Ban Tôn giáo Quận BT', style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.inkSoft,
                    )),
                    const SizedBox(width: 8),
                    Text('·', style: GoogleFonts.inter(color: AppColors.inkFaint)),
                    const SizedBox(width: 8),
                    Text('14/05/2026 · 5 phút đọc', style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.inkSoft,
                    )),
                  ]),
                ],
              ),
            ),
          ),

          // Hero image
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: const ImgPlaceholder(
                      width: double.infinity, height: 220,
                      tag: 'lễ trao quyết định · sân uỷ ban',
                      variant: ImgVariant.warm,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đại diện Ban Tôn giáo Quận trao quyết định công nhận cho trụ trì Tịnh xá Ngọc Phương.',
                    style: GoogleFonts.inter(
                      fontSize: 13, fontStyle: FontStyle.italic, color: AppColors.inkSoft,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sáng ngày 14/05/2026 tại trụ sở UBND Phường 5, Quận Bình Thạnh, Ban Tôn giáo Quận đã long trọng tổ chức Lễ trao quyết định công nhận Tịnh xá Ngọc Phương là cơ sở tôn giáo thuộc hệ phái Khất sĩ.',
                    style: GoogleFonts.inter(
                      fontSize: 16, height: 1.55, color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Tịnh xá Ngọc Phương được xây dựng từ năm 1971, hiện có 4 vị Tỳ kheo cùng khoảng 320 Phật tử sinh hoạt thường xuyên. Quá trình hoàn thiện hồ sơ kéo dài 14 tháng với sự phối hợp giữa nhà chùa và phòng Nội vụ.',
                    style: GoogleFonts.inter(
                      fontSize: 16, height: 1.55, color: AppColors.inkMuted,
                    ),
                  ),

                  // Pull-quote
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.only(left: 16),
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: AppColors.gold, width: 3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"Việc công nhận là sự ghi nhận của Nhà nước với một quá trình hoạt động tín ngưỡng nghiêm túc, gắn bó với cộng đồng địa phương."',
                          style: GoogleFonts.inter(
                            fontSize: 17, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic,
                            color: AppColors.ink, letterSpacing: -0.01, height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('— Trưởng phòng Nội vụ Phường 5', style: GoogleFonts.inter(
                          fontSize: 13, color: AppColors.inkSoft,
                        )),
                      ],
                    ),
                  ),

                  Text(
                    'Sau lễ trao quyết định, Tịnh xá Ngọc Phương chính thức được cập nhật vào danh mục cơ sở tôn giáo trên hệ thống bản đồ số GIS của phường.',
                    style: GoogleFonts.inter(
                      fontSize: 16, height: 1.55, color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Related
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Liên quan', style: GoogleFonts.inter(
                    fontSize: 19, fontWeight: FontWeight.w600,
                    color: AppColors.ink, letterSpacing: -0.015,
                  )),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: const ImgPlaceholder(width: 110, height: 110, tag: 'hồ sơ'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const StatusPill(kind: PillKind.slate, label: 'hồ sơ', fontSize: 10.5),
                          const SizedBox(height: 6),
                          Text('Quy trình xét duyệt công nhận cơ sở tôn giáo', style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink,
                          )),
                          const SizedBox(height: 4),
                          Text('6 bước từ nộp hồ sơ đến trao quyết định, thời gian trung bình 12-18 tháng…',
                              style: GoogleFonts.inter(fontSize: 13, color: AppColors.inkSoft),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyNavDelegate extends SliverPersistentHeaderDelegate {
  final double top;
  final VoidCallback onBack;
  const _StickyNavDelegate({required this.top, required this.onBack});

  @override
  double get minExtent => top + 60;
  @override
  double get maxExtent => top + 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.parchment.withValues(alpha: 0.92),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, top + 8, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.canvas, shape: BoxShape.circle,
                  border: Border.all(color: AppColors.hairline),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.ink),
              ),
            ),
            Row(children: [
              const CircleIconButton(icon: Icons.bookmark_border_rounded),
              const SizedBox(width: 8),
              const CircleIconButton(icon: Icons.ios_share_rounded),
            ]),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyNavDelegate old) => false;
}

