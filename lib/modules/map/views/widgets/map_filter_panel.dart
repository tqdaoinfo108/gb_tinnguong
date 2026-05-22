import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../data/models/map_layer_model.dart';
import '../../controllers/map_controller.dart';

/// Panel bộ lọc + cài đặt lớp bản đồ.
/// Hiện dưới dạng bottom-sheet modal trong Stack của màn hình chính.
class MapFilterPanel extends GetView<GisMapController> {
  const MapFilterPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final screenH = MediaQuery.of(context).size.height;

    return Obx(() {
      if (!controller.showFilterPanel.value) return const SizedBox.shrink();

      return Stack(children: [
        // ── Scrim ──────────────────────────────────────────────────
        GestureDetector(
          onTap: controller.toggleFilterPanel,
          child: Container(color: Colors.black.withValues(alpha: 0.40)),
        ),

        // ── Bottom sheet ────────────────────────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            constraints: BoxConstraints(maxHeight: screenH * 0.78),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle + header (fixed)
                _SheetHeader(onClose: controller.toggleFilterPanel),

                // Scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: bottom + 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ① Lớp nền ──────────────────────────────────
                        _SectionLabel('Lớp nền bản đồ'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _BaseLayerGrid(controller: controller),
                        ),

                        const SizedBox(height: 6),
                        _Separator(),

                        // ② Tôn giáo ─────────────────────────────────
                        _SectionLabel('Tôn giáo'),
                        ...controller.religions.map((r) {
                          final visible = controller.visibleReligionIDs
                              .contains(r.religionID);
                          final colorVal =
                              GisMapController.religionColors[r.religionID];
                          final color = colorVal != null
                              ? Color(colorVal)
                              : AppColors.inkSoft;
                          final count =
                              controller.religionMarkerCounts[r.religionID] ??
                                  0;
                          return _FilterRow(
                            color: color,
                            label: r.religionName,
                            count: count,
                            visible: visible,
                            onToggle: () =>
                                controller.toggleReligion(r.religionID),
                          );
                        }),

                        _Separator(indent: 20),

                        // ④ Phân loại ─────────────────────────────────
                        _SectionLabel('Phân loại'),
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
}

// ── Sheet header ──────────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  final VoidCallback onClose;
  const _SheetHeader({required this.onClose});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(height: 10),
      Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.hairlineStrong,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 8, 6),
        child: Row(children: [
          const Icon(Icons.layers_rounded, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'Bản đồ & Lớp hiển thị',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              letterSpacing: -0.01,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded,
                size: 20, color: AppColors.inkMuted),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ]),
      ),
      Divider(height: 1, color: AppColors.hairline),
    ],
  );
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
    child: Text(
      text.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.inkFaint,
        letterSpacing: 0.08,
      ),
    ),
  );
}

class _Separator extends StatelessWidget {
  final double indent;
  const _Separator({this.indent = 0});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: indent),
    child: Divider(height: 1, color: AppColors.hairline),
  );
}

// ── Base layer grid (2×2 cards) ───────────────────────────────────────────────

class _BaseLayerGrid extends StatelessWidget {
  final GisMapController controller;
  const _BaseLayerGrid({required this.controller});

  @override
  Widget build(BuildContext context) => Obx(() {
    final current = controller.baseLayer.value;
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.55,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: MapBaseLayer.values
          .map((layer) => _LayerCard(
                layer: layer,
                selected: layer == current,
                onTap: () => controller.setBaseLayer(layer),
              ))
          .toList(),
    );
  });
}

class _LayerCard extends StatelessWidget {
  final MapBaseLayer layer;
  final bool selected;
  final VoidCallback onTap;
  const _LayerCard({
    required this.layer,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: layer.previewBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppColors.primary : Colors.transparent,
          width: 2.5,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.20),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [AppColors.lightShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon + check
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: layer.previewFg.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(layer.icon, size: 18, color: layer.previewFg),
                ),
                if (selected)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 13, color: Colors.white),
                  ),
              ],
            ),
            // Label + description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  layer.label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: layer.previewFg,
                  ),
                ),
                Text(
                  layer.description,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: layer.previewFg.withValues(alpha: 0.65),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
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
  Widget build(BuildContext context) => InkWell(
    onTap: onToggle,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
      child: Row(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: visible ? color : color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
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
        // Toggle switch
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 20,
          decoration: BoxDecoration(
            color: visible ? AppColors.primary : AppColors.hairlineStrong,
            borderRadius: BorderRadius.circular(999),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 150),
            alignment:
                visible ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.all(2),
              width: 16,
              height: 16,
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
