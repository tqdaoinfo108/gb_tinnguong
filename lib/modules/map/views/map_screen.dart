import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/map_controller.dart';
import 'widgets/map_filter_panel.dart';
import 'widgets/facility_popup.dart';
import 'widgets/facility_list_sheet.dart';
import 'widgets/image_lightbox.dart';

class MapScreen extends GetView<GisMapController> {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.mapBg,
      body: Obx(() {
        // ── Loading state ──
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16),
                Text('Đang tải bản đồ…',
                    style: TextStyle(color: AppColors.inkSoft)),
              ],
            ),
          );
        }

        return Stack(
          children: [
            // ── Map ──
            Positioned.fill(
              child: _buildMap(),
            ),



            // ── Legend ──
            Positioned(
              left: 16,
              top: top + 68,
              child: _buildLegend(),
            ),

            // ── Filter panel (slide from left) ──
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: const MapFilterPanel(),
            ),

            // ── Right toolbar ──
            Positioned(
              right: 14,
              top: top + 120,
              child: _buildRightToolbar(),
            ),

            // ── Bottom sheet ──
            if (controller.selectedOffice.value != null)
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FacilityPopup(),
              )
            else
              DraggableScrollableSheet(
                initialChildSize: 0.45,
                minChildSize: 0.12,
                maxChildSize: 0.92,
                snap: true,
                snapSizes: const [0.12, 0.45, 0.92],
                builder: (context, scrollController) {
                  return FacilityListSheet(
                    scrollController: scrollController,
                  );
                },
              ),

            // ── Lightbox overlay ──
            if (controller.selectedAlbum.value != null)
              const Positioned.fill(child: ImageLightbox()),
          ],
        );
      }),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // MAP
  // ═══════════════════════════════════════════════════════════════
  Widget _buildMap() {
    return Obx(() {
      final offices = controller.filteredOffices;
      final boundary = controller.boundaryPoints;
      final route = controller.routePoints;
      final userLoc = controller.userLocation.value;
      final selectedID = controller.selectedOffice.value?.officeID;

      return FlutterMap(
        mapController: controller.mapController,
        options: MapOptions(
          initialCenter: controller.initialCenter,
          initialZoom: 13.0,
          onTap: (_, _) => controller.closePopup(),
        ),
        children: [
          // Tile layer — Google Maps style (matching design)
          TileLayer(
            urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
            userAgentPackageName: 'com.tinnguong.gis',
          ),

          // ── Boundary polygon (3 layers) ──
          if (boundary.length >= 3)
            PolygonLayer(polygons: [
              // Layer 1: Fill mờ
              Polygon(
                points: boundary.toList(),
                color: const Color(0xFF3B6FA0).withValues(alpha: 0.06),
                borderColor: Colors.transparent,
                borderStrokeWidth: 0,
              ),
              // Layer 2: Glow
              Polygon(
                points: boundary.toList(),
                color: Colors.transparent,
                borderColor:
                    const Color(0xFF3B6FA0).withValues(alpha: 0.20),
                borderStrokeWidth: 6,
              ),
              // Layer 3: Đường viền chính
              Polygon(
                points: boundary.toList(),
                color: Colors.transparent,
                borderColor: const Color(0xFF3B6FA0),
                borderStrokeWidth: 2.5,
              ),
            ]),

          // ── Route polyline ──
          if (route.isNotEmpty)
            PolylineLayer(polylines: [
              Polyline(
                points: route.toList(),
                color: AppColors.primary,
                strokeWidth: 4,
              ),
            ]),

          // ── User location marker ──
          if (userLoc != null)
            MarkerLayer(markers: [
              Marker(
                point: userLoc,
                width: 20,
                height: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.40),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ]),

          // ── Office markers ──
          MarkerLayer(
            markers: offices.map((o) {
              final colorVal =
                  GisMapController.religionColors[o.religionID] ??
                      0xFF8A6E4A;
              final color = Color(colorVal);
              final abbrev =
                  GisMapController.religionAbbrev[o.religionID] ?? '?';
              final isSelected = o.officeID == selectedID;

              return Marker(
                point: LatLng(o.latitude!, o.longitude!),
                width: isSelected ? 34 : 26,
                height: isSelected ? 34 : 26,
                child: GestureDetector(
                  onTap: () => controller.onMarkerTap(o),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: isSelected ? 3 : 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? color.withValues(alpha: 0.45)
                              : Colors.black.withValues(alpha: 0.25),
                          blurRadius: isSelected ? 12 : 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        abbrev,
                        style: GoogleFonts.inter(
                          fontSize: isSelected ? 13 : 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════
  // LEGEND
  // ═══════════════════════════════════════════════════════════════
  Widget _buildLegend() {
    return Obx(() {
      final counts = controller.religionMarkerCounts;
      final religions = controller.religions;
      // Show first 3 religions with counts, then "+N"
      final visible = religions
          .where((r) =>
              controller.visibleReligionIDs.contains(r.religionID))
          .toList();
      final showCount = visible.length > 3 ? 3 : visible.length;
      final remaining = visible.length - showCount;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'HIỂN THỊ',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.inkSoft,
                letterSpacing: 0.06,
              ),
            ),
            const SizedBox(width: 10),
            ...visible.take(showCount).map((r) {
              final colorVal =
                  GisMapController.religionColors[r.religionID] ??
                      0xFF8A6E4A;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _LegendDot(
                  color: Color(colorVal),
                  count: '${counts[r.religionID] ?? 0}',
                ),
              );
            }),
            if (remaining > 0)
              Text(
                '+$remaining',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkFaint,
                ),
              ),
          ],
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════
  // RIGHT TOOLBAR
  // ═══════════════════════════════════════════════════════════════
  Widget _buildRightToolbar() {
    return Column(
      children: [
        _IconBtn(icon: Icons.add_rounded, onTap: controller.zoomIn),
        const SizedBox(height: 8),
        _IconBtn(icon: Icons.remove_rounded, onTap: controller.zoomOut),
        const SizedBox(height: 8),
        _IconBtn(
            icon: Icons.fullscreen_rounded, onTap: controller.fitBoundary),
        const SizedBox(height: 8),
        _IconBtn(
            icon: Icons.my_location_rounded,
            onTap: controller.goToMyLocation),
      ],
    );
  }
}

// ─── Reusable small widgets ─────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.hairline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: AppColors.inkMuted),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String count;
  const _LegendDot({required this.color, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          count,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}
