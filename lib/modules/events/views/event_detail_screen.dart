import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../widgets/img_placeholder.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ImgPlaceholder(variant: ImgVariant.warm, tag: 'đại lễ phật đản'),
                  // Gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x801E2D3D), Colors.transparent, Colors.transparent, Color(0xB31E2D3D)],
                        stops: [0, 0.3, 0.5, 1],
                      ),
                    ),
                  ),
                  // Nav
                  Positioned(
                    left: 16, right: 16, top: top + 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _NavBtn(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.pop(context)),
                        _NavBtn(icon: Icons.ios_share_rounded, onTap: () {}),
                      ],
                    ),
                  ),
                  // Title overlay
                  Positioned(
                    left: 20, right: 20, bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle,
                            )),
                            const SizedBox(width: 6),
                            Text('Sắp diễn ra', style: GoogleFonts.inter(
                              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white,
                            )),
                          ]),
                        ),
                        const SizedBox(height: 10),
                        Text('Đại lễ Phật Đản', style: GoogleFonts.inter(
                          fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white,
                          letterSpacing: -0.02, height: 1.18,
                        )),
                        const SizedBox(height: 4),
                        Text('Phật lịch 2570 · Dương lịch 2026', style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quick facts card
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.hairline),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20, offset: const Offset(0, 4),
                    )],
                  ),
                  child: Column(children: [
                    _FactRow(icon: Icons.calendar_month_rounded, label: 'Thời gian', value: '18 – 22 / 05 / 2026'),
                    const Divider(color: AppColors.hairline, height: 25),
                    _FactRow(icon: Icons.location_on_outlined, label: 'Địa điểm', value: 'Chùa Pháp Hoa · 870/53 Lê Quang Định'),
                    const Divider(color: AppColors.hairline, height: 25),
                    _FactRow(icon: Icons.people_outline_rounded, label: 'Tham dự dự kiến', value: '~ 2.500 người'),
                    const Divider(color: AppColors.hairline, height: 25),
                    _FactRow(icon: Icons.verified_rounded, label: 'Giấy phép', value: 'Đã cấp · GP-018/2026', emerald: true),
                  ]),
                ),
              ),
            ),
          ),

          // Description
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nội dung sự kiện', style: _h2),
                  const SizedBox(height: 8),
                  Text(
                    'Đại lễ Phật Đản được tổ chức trong 5 ngày, gồm các nghi lễ tắm Phật, thuyết pháp, diễu hành xe hoa, văn nghệ Phật giáo, và bữa cơm chay đãi khách thập phương. Sự kiện được tổ chức bởi Ban Trị sự Phật giáo Quận Bình Thạnh phối hợp với Chùa Pháp Hoa.',
                    style: GoogleFonts.inter(
                      fontSize: 15, height: 1.55, color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Schedule
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chương trình', style: _h2),
                  const SizedBox(height: 12),
                  const _ScheduleRow(time: '06:00', title: 'Khai mạc – Tụng kinh khai lễ'),
                  const _ScheduleRow(time: '09:00', title: 'Lễ tắm Phật'),
                  const _ScheduleRow(time: '14:00', title: 'Thuyết pháp – Ý nghĩa Phật Đản'),
                  const _ScheduleRow(time: '18:00', title: 'Diễu hành xe hoa quanh phường'),
                  const _ScheduleRow(time: '19:30', title: 'Văn nghệ – Bế mạc', last: true),
                ],
              ),
            ),
          ),

          // Organizer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Đơn vị tổ chức', style: _h2),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.canvas,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Row(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.goldPillBg, borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Container(
                          width: 10, height: 10,
                          decoration: BoxDecoration(color: AppColors.buddhism, shape: BoxShape.circle),
                        )),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Chùa Pháp Hoa', style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink,
                          )),
                          Text('Phật giáo · Phường 5', style: _cap),
                        ],
                      )),
                      const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.inkFaint),
                    ]),
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

class _FactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool emerald;
  const _FactRow({required this.icon, required this.label, required this.value, this.emerald = false});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(color: AppColors.parchment, borderRadius: BorderRadius.circular(9)),
        child: Icon(icon, size: 16, color: AppColors.inkMuted),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.w500,
            color: AppColors.inkSoft, letterSpacing: 0.06,
          )),
          const SizedBox(height: 1),
          Text(value, style: GoogleFonts.inter(
            fontSize: 15, fontWeight: FontWeight.w600,
            color: emerald ? AppColors.emeraldFg : AppColors.ink,
          )),
        ],
      )),
    ]);
  }
}

class _ScheduleRow extends StatelessWidget {
  final String time;
  final String title;
  final bool last;
  const _ScheduleRow({required this.time, required this.title, this.last = false});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(time, style: GoogleFonts.jetBrainsMono(
                fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink,
              )),
            ),
          ),
          const SizedBox(width: 4),
          Column(
            children: [
              Container(
                width: 8, height: 8, margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              ),
              if (!last)
                Expanded(child: Container(
                  width: 1.5, color: AppColors.hairline, margin: const EdgeInsets.only(top: 2),
                )),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 14),
              child: Text(title, style: GoogleFonts.inter(
                fontSize: 15, color: AppColors.ink,
              )),
            ),
          ),
        ],
      ),
    );
  }
}

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
        ),
        child: Icon(icon, size: 18, color: AppColors.ink),
      ),
    );
  }
}

final _h2 = GoogleFonts.inter(
  fontSize: 19, fontWeight: FontWeight.w600,
  color: AppColors.ink, letterSpacing: -0.015,
);
final _cap = AppTextStyles.cap;
