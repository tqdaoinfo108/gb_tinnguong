import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/app_colors.dart';
import '../../controllers/map_controller.dart';

/// Panel trái — toggle ẩn/hiện nhóm marker theo tôn giáo + phân loại.
class MapFilterPanel extends GetView<GisMapController> {
  const MapFilterPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Obx(() {
      if (!controller.showFilterPanel.value) return const SizedBox.shrink();
      return Container(
        width: 260,
        margin: EdgeInsets.only(top: top + 60, bottom: 100, left: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.layers_rounded,
                          size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'LỚP BẢN ĐỒ',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.inkSoft,
                          letterSpacing: 0.08,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // ── Tôn giáo ──
                _SectionLabel(label: 'Tôn giáo'),
                ...controller.religions.map((r) {
                  final visible =
                      controller.visibleReligionIDs.contains(r.religionID);
                  final colorVal =
                      GisMapController.religionColors[r.religionID];
                  final color = colorVal != null
                      ? Color(colorVal)
                      : AppColors.inkSoft;
                  final count =
                      controller.religionMarkerCounts[r.religionID] ?? 0;
                  return _FilterRow(
                    color: color,
                    label: r.religionName,
                    count: count,
                    visible: visible,
                    onToggle: () => controller.toggleReligion(r.religionID),
                  );
                }),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Divider(height: 1, color: AppColors.hairline),
                ),

                // ── Phân loại dữ liệu ──
                _SectionLabel(label: 'Phân loại'),
                ...controller.classDataList.map((c) {
                  final visible =
                      controller.visibleClassDataIDs.contains(c.classDataID);
                  return _FilterRow(
                    color: AppColors.primary,
                    label: c.classDataName,
                    count: null,
                    visible: visible,
                    onToggle: () => controller.toggleClassData(c.classDataID),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.inkFaint,
          letterSpacing: 0.06,
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final Color color;
  final String label;
  final int? count;
  final bool visible;
  final VoidCallback onToggle;

  const _FilterRow({
    required this.color,
    required this.label,
    required this.count,
    required this.visible,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: visible ? color : color.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: visible ? AppColors.ink : AppColors.inkFaint,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 4),
              Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkFaint,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              visible
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 18,
              color: visible ? AppColors.primary : AppColors.inkFaint,
            ),
          ],
        ),
      ),
    );
  }
}
