import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../../../data/models/map_layer_model.dart';
import '../controllers/map_controller.dart';
import 'widgets/map_filter_panel.dart';
import 'widgets/facility_popup.dart';
import 'widgets/image_lightbox.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final GisMapController ctrl;
  final _sheetCtrl = DraggableScrollableController();
  final _searchFocus = FocusNode();
  final _searchTextCtrl = TextEditingController();
  bool _searchActive = false;
  bool _initialMoveDone = false;

  @override
  void initState() {
    super.initState();
    ctrl = Get.find<GisMapController>();
  }

  @override
  void dispose() {
    _sheetCtrl.dispose();
    _searchFocus.dispose();
    _searchTextCtrl.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _searchActive = true);
    // Collapse bottom sheet to give room for results overlay
    if (_sheetCtrl.isAttached) {
      _sheetCtrl.animateTo(
        0.11,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _searchFocus.requestFocus();
    });
  }

  void _closeSearch() {
    _searchFocus.unfocus();
    _searchTextCtrl.clear();
    ctrl.searchQuery.value = '';
    setState(() => _searchActive = false);
    if (_sheetCtrl.isAttached) {
      _sheetCtrl.animateTo(
        0.40,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.mapBg,
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16),
                Text(
                  'Đang tải bản đồ…',
                  style: TextStyle(color: AppColors.inkSoft),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            // ① Map
            Positioned.fill(child: _buildMap()),

            // ② Top gradient
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _TopGradient(height: top + 120),
            ),

            // ③ Search overlay (scrim + results) — behind toolbar
            if (_searchActive)
              Positioned.fill(
                child: _SearchOverlay(
                  ctrl: ctrl,
                  top: top,
                  searchFocus: _searchFocus,
                  searchTextCtrl: _searchTextCtrl,
                  onClose: _closeSearch,
                  bottom: bottom,
                ),
              ),

            // ④ Top bar (pill or active search bar)
            Positioned(
              top: top + 12,
              left: 16,
              right: 16,
              child: _searchActive
                  ? _ActiveSearchBar(
                      ctrl: ctrl,
                      focusNode: _searchFocus,
                      textCtrl: _searchTextCtrl,
                      onClose: _closeSearch,
                    )
                  : _TopBar(ctrl: ctrl, onSearchTap: _openSearch),
            ),

            // ⑤ Right toolbar
            Positioned(right: 14, top: top + 72, child: _buildRightToolbar()),

            // ⑥ Bottom sheet (hidden while search active)
            if (ctrl.selectedOffice.value != null)
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FacilityPopup(),
              ),

            // ⑦ Filter panel modal — always above bottom sheet
            Positioned.fill(child: const MapFilterPanel()),

            // ⑧ Lightbox (topmost)
            if (ctrl.selectedAlbum.value != null)
              const Positioned.fill(child: ImageLightbox()),
          ],
        );
      }),
    );
  }

  Widget _buildMap() => Obx(() {
    final offices = ctrl.filteredOffices;
    final boundary = ctrl.boundaryPoints;
    final route = ctrl.routePoints;
    final userLoc = ctrl.userLocation.value;
    final selectedID = ctrl.selectedOffice.value?.officeID;

    return FlutterMap(
      mapController: ctrl.mapController,
      options: MapOptions(
        initialCenter: ctrl.initialCenter,
        initialZoom: 13.0,
        onMapReady: () {
          // Chỉ fit 1 lần duy nhất khi map render xong lần đầu
          if (!_initialMoveDone) {
            _initialMoveDone = true;
            ctrl.fitBoundary();
            // Fetch POI đã lưu (viewport sẵn sàng từ lúc này)
            ctrl.onMapReadyFetchPois();
          }
        },
        onTap: (tp, latlng) {
          ctrl.closePopup();
          if (_searchActive) _closeSearch();
        },
      ),
      children: [
        // ── Tile layer — chọn động theo baseLayer ──────────────────
        ..._buildTileLayers(ctrl.baseLayer.value),

        // ── Boundary polygon ─────────────────────────────────────────
        if (boundary.length >= 3)
          PolygonLayer(
            polygons: [
              Polygon(
                points: boundary.toList(),
                color: AppColors.primary.withValues(alpha: 0.05),
                borderColor: Colors.transparent,
                borderStrokeWidth: 0,
              ),
              Polygon(
                points: boundary.toList(),
                color: Colors.transparent,
                borderColor: (ctrl.baseLayer.value.isDark
                        ? Colors.white
                        : AppColors.primary)
                    .withValues(alpha: 0.18),
                borderStrokeWidth: 8,
              ),
              Polygon(
                points: boundary.toList(),
                color: Colors.transparent,
                borderColor: ctrl.baseLayer.value.isDark
                    ? Colors.white.withValues(alpha: 0.75)
                    : AppColors.primary.withValues(alpha: 0.75),
                borderStrokeWidth: 2,
              ),
            ],
          ),

        // ── Route polyline ────────────────────────────────────────────
        if (route.isNotEmpty)
          PolylineLayer(
            polylines: [
              // Shadow
              Polyline(
                points: route.toList(),
                color: AppColors.primary.withValues(alpha: 0.20),
                strokeWidth: 8,
              ),
              // Line chính
              Polyline(
                points: route.toList(),
                color: AppColors.primary,
                strokeWidth: 4,
              ),
            ],
          ),

        // ── Vị trí người dùng ─────────────────────────────────────────
        if (userLoc != null)
          MarkerLayer(
            markers: [
              Marker(
                point: userLoc,
                width: 22,
                height: 22,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F80ED),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2F80ED).withValues(alpha: 0.45),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        // ── Markers cơ sở tín ngưỡng ──────────────────────────────────
        MarkerLayer(
          markers: offices.map((o) {
            final colorVal =
                GisMapController.religionColors[o.religionID] ?? 0xFF8A6E4A;
            final color = Color(colorVal);
            final abbrev = GisMapController.religionAbbrev[o.religionID] ?? '?';
            final isSel = o.officeID == selectedID;

            return Marker(
              point: LatLng(o.latitude!, o.longitude!),
              width:  isSel ? 42 : 32,
              height: isSel ? 42 : 32,
              child: GestureDetector(
                onTap: () => ctrl.onMarkerTap(o),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: isSel ? 3.0 : 2.5,
                    ),
                    boxShadow: isSel
                        ? [
                            // Glow khi được chọn
                            BoxShadow(
                              color: color.withValues(alpha: 0.55),
                              blurRadius: 18,
                              spreadRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [
                            // Shadow chuẩn khi không chọn
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.30),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),
                  child: Center(
                    child: Text(
                      abbrev,
                      style: GoogleFonts.inter(
                        fontSize: isSel ? 15 : 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 2,
                          ),
                        ],
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

  Widget _buildRightToolbar() => Column(
    children: [
      _ToolGroup(
        children: [
          _MapBtn(icon: Icons.add_rounded, onTap: ctrl.zoomIn),
          _MapBtn(icon: Icons.remove_rounded, onTap: ctrl.zoomOut),
        ],
      ),
      const SizedBox(height: 8),
      _MapBtn(icon: Icons.fullscreen_rounded, onTap: ctrl.fitBoundary),
      const SizedBox(height: 8),
      _MapBtn(icon: Icons.my_location_rounded, onTap: ctrl.goToMyLocation),
    ],
  );
}

// ── Search overlay (scrim + result list) ─────────────────────────────────────

class _SearchOverlay extends StatelessWidget {
  final GisMapController ctrl;
  final double top;
  final double bottom;
  final FocusNode searchFocus;
  final TextEditingController searchTextCtrl;
  final VoidCallback onClose;

  const _SearchOverlay({
    required this.ctrl,
    required this.top,
    required this.bottom,
    required this.searchFocus,
    required this.searchTextCtrl,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scrim — tap to close
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(color: Colors.black.withValues(alpha: 0.30)),
          ),
        ),

        // Result panel — floats below the search bar
        Positioned(
          top: top + 70, // just below the search bar (46px) + 12 top + 12 gap
          left: 16,
          right: 16,
          child: Obx(() {
            final q       = ctrl.searchQuery.value.trim();
            final results = ctrl.searchResults;
            final workUnit = ctrl.userWorkUnit;

            // Khi chưa gõ gì: hiện chip WorkUnit nếu có (từ cache profile)
            if (q.isEmpty) {
              if (workUnit == null) return const SizedBox.shrink();
              return _WorkUnitSuggestion(
                workUnit: workUnit,
                onTap: () {
                  searchTextCtrl.text = workUnit;
                  ctrl.searchQuery.value = workUnit;
                },
              );
            }

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.55,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [AppColors.cardShadowStrong],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Count header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                      child: Row(
                        children: [
                          Text(
                            results.isEmpty
                                ? 'Không tìm thấy kết quả'
                                : '${results.length} kết quả cho "$q"',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: results.isEmpty
                                  ? AppColors.inkFaint
                                  : AppColors.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (results.isNotEmpty) ...[
                      Divider(height: 1, color: AppColors.hairline),
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: results.length,
                          separatorBuilder: (_, i) => Divider(
                            height: 1,
                            color: AppColors.hairline,
                            indent: 64,
                          ),
                          itemBuilder: (ctx, i) {
                            final o = results[i];
                            final colorVal =
                                GisMapController.religionColors[o.religionID] ??
                                0xFF8A6E4A;
                            final color = Color(colorVal);
                            final abbrev =
                                GisMapController.religionAbbrev[o.religionID] ??
                                '?';
                            return InkWell(
                              onTap: () {
                                onClose();
                                ctrl.onSearchResultTap(o);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    // Marker avatar
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              abbrev,
                                              style: GoogleFonts.inter(
                                                fontSize: 8,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            o.officeName,
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.ink,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (o.officeAddress != null)
                                            Text(
                                              o.officeAddress!,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: AppColors.inkSoft,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (o.religionName != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.10),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: Text(
                                          o.religionName!,
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: color,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Active search bar (replaces pill when searching) ──────────────────────────

class _ActiveSearchBar extends StatelessWidget {
  final GisMapController ctrl;
  final FocusNode focusNode;
  final TextEditingController textCtrl;
  final VoidCallback onClose;

  const _ActiveSearchBar({
    required this.ctrl,
    required this.focusNode,
    required this.textCtrl,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onClose,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: AppColors.inkMuted,
              ),
            ),
          ),

          // Text field
          Expanded(
            child: TextField(
              focusNode: focusNode,
              controller: textCtrl,
              autofocus: true,
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.ink),
              decoration: InputDecoration(
                hintText: 'Tìm cơ sở, địa chỉ…',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.inkFaint,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
              ),
              onChanged: (v) => ctrl.searchQuery.value = v,
              textInputAction: TextInputAction.search,
            ),
          ),

          // Clear button
          Obx(
            () => ctrl.searchQuery.value.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      textCtrl.clear();
                      ctrl.searchQuery.value = '';
                      focusNode.requestFocus();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.inkFaint,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(width: 12),
          ),
        ],
      ),
    );
  }
}

// ── Default top bar (pill + filter) ──────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final GisMapController ctrl;
  final VoidCallback onSearchTap;
  const _TopBar({required this.ctrl, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search pill
        Expanded(
          child: GestureDetector(
            onTap: onSearchTap,
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.97),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.hairline),
                boxShadow: [AppColors.lightShadow],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: AppColors.inkSoft,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tìm cơ sở, địa chỉ…',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.inkFaint,
                      ),
                    ),
                  ),
                  // Mini religion dots
                  Obx(() {
                    final counts = ctrl.religionMarkerCounts;
                    final religions = ctrl.religions
                        .where(
                          (r) =>
                              ctrl.visibleReligionIDs.contains(r.religionID) &&
                              (counts[r.religionID] ?? 0) > 0,
                        )
                        .take(5)
                        .toList();
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: religions.map((r) {
                        final c = Color(
                          GisMapController.religionColors[r.religionID] ??
                              0xFF8A6E4A,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Filter toggle
        Obx(() {
          final active = ctrl.showFilterPanel.value;
          return GestureDetector(
            onTap: ctrl.toggleFilterPanel,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary
                    : Colors.white.withValues(alpha: 0.97),
                shape: BoxShape.circle,
                border: Border.all(
                  color: active ? AppColors.primary : AppColors.hairline,
                ),
                boxShadow: [AppColors.lightShadow],
              ),
              child: Icon(
                Icons.tune_rounded,
                size: 20,
                color: active ? Colors.white : AppColors.inkMuted,
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _TopGradient extends StatelessWidget {
  final double height;
  const _TopGradient({required this.height});
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.82),
            Colors.white.withValues(alpha: 0.0),
          ],
          stops: const [0.45, 1.0],
        ),
      ),
    ),
  );
}

class _ToolGroup extends StatelessWidget {
  final List<Widget> children;
  const _ToolGroup({required this.children});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.97),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.hairline),
      boxShadow: [AppColors.lightShadow],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: children.indexed.map((e) {
        final (i, child) = e;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (i > 0)
              Divider(height: 1, thickness: 1, color: AppColors.hairline),
            child,
          ],
        );
      }).toList(),
    ),
  );
}

class _MapBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MapBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 42,
      height: 42,
      child: Icon(icon, size: 20, color: AppColors.inkMuted),
    ),
  );
}

// ── Helper: xây tile layers theo lựa chọn ────────────────────────────────────

/// Warm ColorFilter — áp lên CartoDB Positron để match palette parchment.
const _warmFilter = ColorFilter.matrix(<double>[
  1.0, 0.0, 0.0, 0,  -6,
  0.0, 1.0, 0.0, 0, -10,
  0.0, 0.0, 1.0, 0, -20,
  0.0, 0.0, 0.0, 1,   0,
]);

// ── WorkUnit suggestion chip ─────────────────────────────────────────────────

class _WorkUnitSuggestion extends StatelessWidget {
  final String workUnit;
  final VoidCallback onTap;
  const _WorkUnitSuggestion({required this.workUnit, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.blueBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Khu vực của bạn',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.inkFaint,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    workUnit,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: AppColors.inkFaint,
            ),
          ],
        ),
      ),
    ),
  );
}

// ── Helper: xây tile layers theo lựa chọn ────────────────────────────────────

List<Widget> _buildTileLayers(MapBaseLayer layer) {
  final mainTile = TileLayer(
    urlTemplate: layer.tileUrl,
    subdomains: layer.subdomains ?? const [],
    userAgentPackageName: 'com.tinnguong.gis',
    maxNativeZoom: 19,
    keepBuffer: 4,
  );

  return [
    if (layer.useWarmFilter)
      ColorFiltered(colorFilter: _warmFilter, child: mainTile)
    else
      mainTile,
  ];
}

