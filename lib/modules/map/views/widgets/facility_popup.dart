import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../data/models/office_model.dart';
import '../../controllers/map_controller.dart';
import 'banner_carousel.dart';
import 'album_grid.dart';
import 'document_list.dart';
import 'events_section.dart';

/// Bottom sheet popup chi tiết cơ sở — hiện khi tap marker.
class FacilityPopup extends GetView<GisMapController> {
  const FacilityPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Obx(() {
      final office = controller.selectedOffice.value;
      if (office == null) return const SizedBox.shrink();

      final colorVal = GisMapController.religionColors[office.religionID] ??
          0xFF8A6E4A;
      final markerColor = Color(colorVal);
      final detail = controller.officeDetail.value;
      final showProfile = controller.showProfileExpanded.value;
      final isLoading = controller.isPopupLoading.value;
      final hasBanners = controller.bannerImages.isNotEmpty;
      final hasAlbums = controller.allAlbums.isNotEmpty;
      final hasDocs = controller.documents.isNotEmpty;
      final hasMediaContent = hasBanners || hasAlbums || hasDocs;

      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.78,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
                color: Color(0x2D000000),
                blurRadius: 32,
                offset: Offset(0, -8)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
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

              // ── Banner carousel (trên cùng, trước body) ──
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: SizedBox(
                    height: 140,
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary, strokeWidth: 2),
                    ),
                  ),
                )
              else if (hasBanners)
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: BannerCarousel(),
                ),

              // ── Body ──
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20, hasBanners || isLoading ? 16 : 14, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Religion dot + Type ──
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: markerColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${office.religionName ?? 'Cơ sở'} · ${office.typeOfficeName ?? 'Tôn giáo'}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkSoft,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.closePopup,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.parchment,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded,
                                size: 16, color: AppColors.inkMuted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // ── Facility Name ──
                    Text(
                      office.officeName,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -0.02,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // ── Address ──
                    if (office.officeAddress != null &&
                        office.officeAddress!.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 15, color: AppColors.inkSoft),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              office.officeAddress!,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: AppColors.inkMuted,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 18),

                    // ── Spec grid ──
                    _SpecGrid(office: office),

                    const SizedBox(height: 14),

                    // ── Người trụ trì ──
                    if (!isLoading)
                      _LeaderCard(ctrl: controller),

                    const SizedBox(height: 14),

                    // ── Status + Xem hồ sơ ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatusBadge(statusName: office.statusName),
                        GestureDetector(
                          onTap: () {
                            if (!showProfile) {
                              controller.onViewProfile(office.officeID);
                            } else {
                              controller.showProfileExpanded.value = false;
                            }
                          },
                          child: Row(
                            children: [
                              if (controller.isProfileLoading.value)
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary),
                                )
                              else
                                Text(
                                  showProfile
                                      ? 'Thu gọn ‹'
                                      : 'Xem hồ sơ ›',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // ── Profile expanded (inline) ──
                    if (showProfile && detail != null) ...[
                      const SizedBox(height: 14),
                      _ProfileSection(detail: detail),
                    ],

                    // ── Sự kiện trong năm ──
                    if (!isLoading) const EventsSection(),

                    // ── Albums section ──
                    if (!isLoading && hasAlbums) const AlbumGrid(),

                    // ── Documents section ──
                    if (!isLoading && hasDocs) const DocumentList(),

                    // ── Empty state (không có media content) ──
                    if (!isLoading && !hasMediaContent)
                      _EmptyMediaState(),

                    const SizedBox(height: 18),

                    // ── Action buttons ──
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              elevation: 0,
                              minimumSize: const Size(0, 48),
                            ),
                            icon: controller.isRouting.value
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.directions_rounded,
                                    size: 16),
                            label: Text(controller.isRouting.value
                                ? 'Đang tìm...'
                                : 'Chỉ đường'),
                            onPressed: controller.isRouting.value
                                ? null
                                : controller.onDirectionTap,
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: hasAlbums
                                ? AppColors.inkMuted
                                : AppColors.inkFaint,
                            side: const BorderSide(
                                color: AppColors.hairline),
                            shape: const StadiumBorder(),
                            minimumSize: const Size(0, 48),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16),
                          ),
                          icon: Icon(
                              Icons.photo_library_outlined,
                              size: 16,
                              color: hasAlbums
                                  ? AppColors.inkMuted
                                  : AppColors.inkFaint),
                          label: const Text('Album'),
                          onPressed: hasAlbums
                              ? () {
                                  // Albums đã hiển thị bên dưới
                                }
                              : null,
                        ),
                        if (controller.routePoints.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.inkMuted,
                              side: const BorderSide(
                                  color: AppColors.hairline),
                              shape: const StadiumBorder(),
                              minimumSize: const Size(0, 48),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                            ),
                            onPressed: controller.clearRoute,
                            child: const Text('Xoá đường'),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 16 + bottom),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ─── Empty media state ──────────────────────────────────────────
class _EmptyMediaState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.parchment2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.photo_camera_outlined,
                size: 20, color: AppColors.inkFaint),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chưa có dữ liệu đa phương tiện',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ảnh, album và văn bản sẽ hiển thị tại đây',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.inkFaint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Spec Grid ──────────────────────────────────────────────────
class _SpecGrid extends StatelessWidget {
  final OfficeModel office;
  const _SpecGrid({required this.office});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          _Spec(
              label: 'Xây dựng',
              value: office.yearBuilt?.toString() ?? '—'),
          _vDivider(),
          _Spec(
            label: 'Diện tích',
            value: office.acreage != null
                ? _formatNum(office.acreage!)
                : '—',
            unit: office.acreage != null ? 'm²' : null,
          ),
          _vDivider(),
          _Spec(
              label: 'Chức sắc',
              value: office.totalUser?.toString() ?? '—'),
          _vDivider(),
          _Spec(
            label: 'Tín đồ',
            value: office.totalBeliever != null
                ? _formatNum(office.totalBeliever!.toDouble())
                : '—',
          ),
        ],
      ),
    );
  }

  Widget _vDivider() =>
      Container(width: 1, height: 60, color: AppColors.hairline);

  String _formatNum(double n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
    }
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }
}

class _Spec extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  const _Spec({required this.label, required this.value, this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: AppColors.inkSoft,
                letterSpacing: 0.06,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.02,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 2),
                  Text(
                    unit!,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Status Badge ───────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String? statusName;
  const _StatusBadge({required this.statusName});

  @override
  Widget build(BuildContext context) {
    final name = statusName ?? 'Chưa rõ';
    final isApproved =
        name.contains('công nhận') || name.contains('Hoạt động');
    final isPending = name.contains('xét') || name.contains('chờ');
    final (bg, fg) = isApproved
        ? (AppColors.emeraldBg, AppColors.emeraldFg)
        : isPending
            ? (AppColors.amberBg, AppColors.amberFg)
            : (AppColors.slateBg, AppColors.slateFg);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        name,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

// ─── Profile Section (Xem hồ sơ expanded) ──────────────────────
class _ProfileSection extends StatelessWidget {
  final OfficeModel detail;
  const _ProfileSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HỒ SƠ CHI TIẾT',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.inkSoft,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: 10),
          _ProfileRow(label: 'Tên cơ sở', value: detail.officeName),
          _ProfileRow(
              label: 'Loại', value: detail.typeOfficeName ?? '—'),
          _ProfileRow(
              label: 'Tôn giáo', value: detail.religionName ?? '—'),
          _ProfileRow(
              label: 'Địa chỉ', value: detail.officeAddress ?? '—'),
          _ProfileRow(
              label: 'Phường/Xã', value: detail.villageName ?? '—'),
          if (detail.latitude != null && detail.longitude != null)
            _ProfileRow(
              label: 'Tọa độ GPS',
              value:
                  '${detail.latitude!.toStringAsFixed(6)}, ${detail.longitude!.toStringAsFixed(6)}',
            ),
          _ProfileRow(
              label: 'Trạng thái', value: detail.statusName ?? '—'),
          if (detail.officeDescription != null &&
              detail.officeDescription!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Mô tả:',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.inkSoft,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              detail.officeDescription!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.ink,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Leader card (người trụ trì) ────────────────────────────────
class _LeaderCard extends StatelessWidget {
  final GisMapController ctrl;
  const _LeaderCard({required this.ctrl});

  @override
  Widget build(BuildContext context) => Obx(() {
    final leader = ctrl.officeLeader.value;

    // Chưa load xong hoặc không có dữ liệu → không render
    if (leader == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [AppColors.lightShadow],
      ),
      child: Row(
        children: [
          // Avatar initials
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B6FA0), Color(0xFF2F5B85)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                leader.initials,
                style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        leader.fullName,
                        style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Status dot
                    if (leader.statusName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          leader.statusName!,
                          style: GoogleFonts.inter(
                            fontSize: 10, fontWeight: FontWeight.w600,
                            color: AppColors.emeraldFg,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  leader.positionName ?? 'Người lãnh đạo',
                  style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),

          // Phone button
          if (leader.phone != null && leader.phone!.isNotEmpty) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: leader.phone!));
                Get.snackbar(
                  'Đã sao chép',
                  leader.phone!,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.emeraldBg,
                  colorText: AppColors.emeraldFg,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  duration: const Duration(seconds: 2),
                );
              },
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: AppColors.blueBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_outlined,
                    size: 17, color: AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  });
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.inkSoft,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
