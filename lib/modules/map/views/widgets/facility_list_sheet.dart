import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../data/models/office_model.dart';
import '../../controllers/map_controller.dart';

/// Bottom sheet danh sách cơ sở, có thể kéo để thu gọn / mở rộng.
///
/// Cấu trúc:
///   - Header (drag handle + tiêu đề + nút "Bộ lọc")  ─ luôn hiển thị
///   - Search input                                    ─ trong list (scroll cùng)
///   - List item                                       ─ scroll trong sheet
///
/// Sheet được DraggableScrollableSheet ở MapScreen quản lý kích thước.
class FacilityListSheet extends GetView<GisMapController> {
  final ScrollController? scrollController;
  const FacilityListSheet({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSearching = controller.searchQuery.value.isNotEmpty;
      final query = controller.searchQuery.value.trim();
      final displayList = isSearching
          ? controller.searchResults
          : controller.filteredOffices;
      final cityLabel = controller.cityName.value.isNotEmpty
          ? controller.cityName.value
          : 'Khu vực';

      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 24,
                offset: Offset(0, -4)),
          ],
        ),
        child: Column(
          children: [
            _Header(
              count: displayList.length,
              isSearching: isSearching,
              query: query,
              cityLabel: cityLabel,
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                itemCount: displayList.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return const _SearchBar();
                  final office = displayList[index - 1];
                  return _FacilityRow(office: office);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─── Header (drag handle + tiêu đề + nút lọc) ───────────────────

class _Header extends StatelessWidget {
  final int count;
  final bool isSearching;
  final String query;
  final String cityLabel;
  const _Header({
    required this.count,
    required this.isSearching,
    required this.query,
    required this.cityLabel,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GisMapController>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        // Drag handle
        Container(
          width: 38,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.hairlineStrong,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSearching ? '$count kết quả' : '$count cơ sở',
                    style: GoogleFonts.inter(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                      letterSpacing: -0.015,
                    ),
                  ),
                  Text(
                    isSearching
                        ? 'Khớp với "$query"'
                        : '$cityLabel · trong ranh giới',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: controller.toggleFilterPanel,
                child: Row(
                  children: [
                    Text(
                      'Bộ lọc',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.inkMuted, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Search bar (sticky đầu list) ───────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GisMapController>();
    return Obx(() {
      final query = controller.searchQuery.value;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.parchment,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded,
                  size: 18, color: AppColors.inkSoft),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.ink),
                  decoration: InputDecoration(
                    hintText: 'Tìm cơ sở, địa chỉ…',
                    hintStyle: GoogleFonts.inter(
                        fontSize: 14, color: AppColors.inkSoft),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (v) => controller.searchQuery.value = v,
                ),
              ),
              if (query.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    controller.searchQuery.value = '';
                    FocusScope.of(context).unfocus();
                  },
                  child: const Icon(Icons.close_rounded,
                      size: 18, color: AppColors.inkFaint),
                ),
            ],
          ),
        ),
      );
    });
  }
}

// ─── Facility row ───────────────────────────────────────────────

class _FacilityRow extends StatelessWidget {
  final OfficeModel office;
  const _FacilityRow({required this.office});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GisMapController>();
    final colorVal =
        GisMapController.religionColors[office.religionID] ?? 0xFF8A6E4A;
    final color = Color(colorVal);

    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        controller.onSearchResultTap(office);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.parchment,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    office.officeName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (office.officeAddress != null)
                    Text(
                      office.officeAddress!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.inkSoft,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (office.religionName != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  office.religionName!,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
