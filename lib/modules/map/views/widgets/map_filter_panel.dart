import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/app_colors.dart';
import '../../controllers/map_controller.dart';

/// Filter panel — appears as a bottom-sheet modal overlay.
/// Placed as Positioned.fill inside map Stack so it can cover the whole screen.
class MapFilterPanel extends GetView<GisMapController> {
  const MapFilterPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Obx(() {
      if (!controller.showFilterPanel.value) return const SizedBox.shrink();

      return Stack(children: [
        // ── Scrim ────────────────────────────────────────────────
        GestureDetector(
          onTap: controller.toggleFilterPanel,
          child: Container(color: Colors.black.withValues(alpha: 0.40)),
        ),

        // ── Bottom sheet ─────────────────────────────────────────
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                const SizedBox(height: 10),
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.hairlineStrong,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 4),

                // Header row
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 8, 4),
                  child: Row(
                    children: [
                      const Icon(Icons.layers_rounded,
                          size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Lớp bản đồ',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          letterSpacing: -0.01,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: controller.toggleFilterPanel,
                        icon: const Icon(Icons.close_rounded,
                            size: 20, color: AppColors.inkMuted),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 420),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: bottom + 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Tôn giáo ──────────────────────────────
                        _sectionLabel('Tôn giáo'),
                        ...controller.religions.map((r) {
                          final visible = controller.visibleReligionIDs
                              .contains(r.religionID);
                          final colorVal =
                              GisMapController.religionColors[r.religionID];
                          final color = colorVal != null
                              ? Color(colorVal)
                              : AppColors.inkSoft;
                          final count = controller.religionMarkerCounts[r.religionID] ?? 0;
                          return _FilterRow(
                            color: color,
                            label: r.religionName,
                            count: count,
                            visible: visible,
                            onToggle: () =>
                                controller.toggleReligion(r.religionID),
                          );
                        }),

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Divider(height: 1, color: AppColors.hairline),
                        ),

                        // ── Phân loại ─────────────────────────────
                        _sectionLabel('Phân loại'),
                        ...controller.classDataList.map((c) {
                          final visible = controller.visibleClassDataIDs
                              .contains(c.classDataID);
                          return _FilterRow(
                            color: AppColors.primary,
                            label: c.classDataName,
                            count: null,
                            visible: visible,
                            onToggle: () =>
                                controller.toggleClassData(c.classDataID),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]);
    });
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
    child: Text(
      label.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.inkFaint,
        letterSpacing: 0.08,
      ),
    ),
  );
}

// ── Filter row ────────────────────────────────────────────────────────────────

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        child: Row(children: [
          // Color dot
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 12, height: 12,
            decoration: BoxDecoration(
              color: visible ? color : color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),

          // Label
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: visible ? AppColors.ink : AppColors.inkFaint,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Count badge
          if (count != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: visible
                    ? color.withValues(alpha: 0.12)
                    : AppColors.parchment,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: visible ? color : AppColors.inkFaint,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],

          // Toggle
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36, height: 20,
            decoration: BoxDecoration(
              color: visible ? AppColors.primary : AppColors.hairlineStrong,
              borderRadius: BorderRadius.circular(999),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 150),
              alignment: visible ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(2),
                width: 16, height: 16,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
