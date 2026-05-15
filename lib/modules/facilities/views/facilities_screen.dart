import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/utils/religion_palette.dart' as palette;
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../data/models/office_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/circle_icon_button.dart';
import '../../../widgets/filter_chip.dart';
import '../../../widgets/img_placeholder.dart';
import '../../../widgets/status_pill.dart';
import '../controllers/facilities_controller.dart';

class FacilitiesScreen extends StatelessWidget {
  const FacilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FacilitiesController());
    final top = MediaQuery.of(context).padding.top;
    final typeFilters = ['Tất cả', 'Chùa', 'Nhà thờ', 'Thánh thất', 'Đình', 'Miếu'];
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
                      Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Cơ sở', style: _hero),
                        Text(
                          'Tín ngưỡng · ${controller.total.value} cơ sở',
                          style: _cap,
                        ),
                      ])),
                      const Row(children: [
                        CircleIconButton(icon: Icons.map_rounded),
                        SizedBox(width: 8),
                        CircleIconButton(icon: Icons.filter_list_rounded),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(children: [
                        const Icon(Icons.search_rounded, size: 18, color: AppColors.inkSoft),
                        const SizedBox(width: 8),
                        Text('Tìm theo tên, địa chỉ…', style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.inkSoft,
                        )),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: FilterChipBar(labels: typeFilters),
            ),
          ),

          // Status filters
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(children: [
                DropChip('Trạng thái: Tất cả'),
                SizedBox(width: 8),
                DropChip('Khu phố'),
              ]),
            ),
          ),

          // Facility cards
          Obx(() {
            if (controller.isLoading.value && controller.facilities.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
                ),
              );
            }
            if (controller.facilities.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: Center(child: Text('Không có dữ liệu', style: _cap)),
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    if (i.isOdd) return const SizedBox(height: 12);
                    final office = controller.facilities[i ~/ 2];
                    return GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.facilityDetail, arguments: office),
                      child: _FacilityCard.fromOffice(office, index: i ~/ 2),
                    );
                  },
                  childCount: controller.facilities.length * 2 - 1,
                ),
              ),
            );
          }),

          // Pagination / bottom spacer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${controller.total.value} cơ sở', style: _cap),
                  const SizedBox(),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── helpers ───────────────────────────────────────────────────

PillKind _statusPill(int? statusID) {
  switch (statusID) {
    case 1: return PillKind.emerald;
    case 2: return PillKind.amber;
    case 3: return PillKind.slate;
    case 4: return PillKind.red;
    default: return PillKind.ghost;
  }
}

ImgVariant _imgVariant(int index) {
  const variants = ImgVariant.values;
  return variants[index % variants.length];
}

// ─── Facility Card ─────────────────────────────────────────────

class _FacilityCard extends StatelessWidget {
  final Color religionColor;
  final String type, name, address;
  final String year, area, followers, clergy;
  final PillKind kind;
  final String statusLabel;
  final ImgVariant variant;
  const _FacilityCard({
    required this.religionColor, required this.type,
    required this.name, required this.address,
    required this.year, required this.area,
    required this.followers, required this.clergy,
    required this.kind, required this.statusLabel, required this.variant,
  });

  factory _FacilityCard.fromOffice(OfficeModel o, {required int index}) => _FacilityCard(
    religionColor: palette.religionColor(o.religionName),
    type: o.typeOfficeName ?? 'Cơ sở',
    name: o.officeName,
    address: o.officeAddress ?? '—',
    year: o.yearBuilt?.toString() ?? '—',
    area: o.acreage?.toStringAsFixed(0) ?? '—',
    followers: o.totalBeliever?.toString() ?? '—',
    clergy: o.totalUser?.toString() ?? '—',
    kind: _statusPill(o.statusID),
    statusLabel: o.statusName ?? '—',
    variant: _imgVariant(index),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.cardShadow],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          SizedBox(
            height: 140,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ImgPlaceholder(variant: variant, tag: '$type · $name'.toLowerCase()),
                Positioned(left: 12, bottom: 12, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 6, height: 6, decoration: BoxDecoration(
                      color: religionColor, shape: BoxShape.circle,
                    )),
                    const SizedBox(width: 5),
                    Text(type, style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink,
                    )),
                  ]),
                )),
                Positioned(right: 12, top: 12, child: StatusPill(kind: kind, label: statusLabel, fontSize: 11)),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.inter(
                  fontSize: 17, fontWeight: FontWeight.w600,
                  color: AppColors.ink, letterSpacing: -0.01,
                )),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 13, color: AppColors.inkSoft),
                  const SizedBox(width: 4),
                  Expanded(child: Text(address, style: _cap)),
                ]),
                const SizedBox(height: 14),
                Row(children: [
                  _MiniStat(label: 'XD', value: year),
                  _MiniStat(label: 'm²', value: area),
                  _MiniStat(label: 'Chức sắc', value: clergy),
                  _MiniStat(label: 'Tín đồ', value: followers),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink, letterSpacing: -0.01,
        )),
        Text(label.toUpperCase(), style: GoogleFonts.inter(
          fontSize: 9, fontWeight: FontWeight.w500, color: AppColors.inkSoft, letterSpacing: 0.04,
        )),
      ],
    ));
  }
}

final _hero = AppTextStyles.hero;
final _cap = AppTextStyles.cap;
