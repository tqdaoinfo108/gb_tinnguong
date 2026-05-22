import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/services/map_service.dart';
import '../../../data/services/overpass_service.dart';
import '../../account/controllers/account_controller.dart';
import '../../../data/models/office_model.dart';
import '../../../data/models/religion_model.dart';
import '../../../data/models/class_data_model.dart';
import '../../../data/models/banner_model.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/event_album_model.dart';
import '../../../data/models/map_layer_model.dart';
import 'package:flutter_map/flutter_map.dart';

class GisMapController extends GetxController {
  final _service = MapService();
  final mapController = MapController();

  // ── Map center — HCMC default ──
  final initialCenter = const LatLng(10.7769, 106.7009);
  final zoom = 13.0.obs;

  // Centroid tính được từ boundary points — dùng để move camera lần đầu
  final boundaryCenter = Rxn<LatLng>();

  // ── Map layer settings (persisted) ───────────────────────────────────────────
  static const _kSettings = 'tinnguong.map.settings';
  final _secStorage = const FlutterSecureStorage();

  final baseLayer    = MapBaseLayer.administrative.obs;
  final poiOverlays  = <PoiCategory>{}.obs;   // danh sách overlay đang bật
  final poiPoints    = <PoiCategory, List<PoiPoint>>{}.obs; // cache kết quả
  final isPoiLoading = false.obs;

  // ── Mount data ──
  final allOffices = <OfficeModel>[].obs;
  final religions = <ReligionModel>[].obs;
  final classDataList = <ClassDataModel>[].obs;
  final boundaryPoints = <LatLng>[].obs;
  final cityName = ''.obs;

  // ── Filter state (toggle show/hide, không gọi lại API) ──
  final visibleReligionIDs = <int>{}.obs;
  final visibleClassDataIDs = <int>{}.obs;
  final showFilterPanel = false.obs;

  // ── Search state ──
  final searchQuery = ''.obs;
  final isSearching = false.obs;

  // ── Popup state ──
  final selectedOffice  = Rxn<OfficeModel>();
  final officeLeader    = Rxn<OfficeLeaderModel>();
  final bannerImages    = <BannerModel>[].obs;
  final documents       = <BannerModel>[].obs;
  final activeEvents    = <EventModel>[].obs;   // sự kiện active hiển thị popup
  final events          = <EventModel>[].obs;   // dùng để load albums
  final allAlbums       = <EventAlbumModel>[].obs;
  final albumImages = <AlbumImageModel>[].obs;
  final selectedAlbum = Rxn<EventAlbumModel>();

  // ── Profile state (Xem hồ sơ) ──
  final officeDetail = Rxn<OfficeModel>();
  final showProfileExpanded = false.obs;

  // ── List Sheet state ──
  final isListSheetExpanded = true.obs;

  // ── Routing state ──
  final routePoints = <LatLng>[].obs;
  final userLocation = Rxn<LatLng>();
  final isRouting = false.obs;

  // ── Loading flags ──
  final isLoading = true.obs;
  final isPopupLoading = false.obs;
  final isProfileLoading = false.obs;
  final isAlbumLoading = false.obs;

  // ── Computed: filtered offices for markers ──
  List<OfficeModel> get filteredOffices {
    return allOffices.where((o) {
      // Must have valid coordinates
      if (o.latitude == null ||
          o.longitude == null ||
          o.latitude == 0 ||
          o.longitude == 0) {
        return false;
      }
      // Filter by religion visibility
      if (o.religionID != null &&
          visibleReligionIDs.isNotEmpty &&
          !visibleReligionIDs.contains(o.religionID)) {
        return false;
      }
      // Filter by classData visibility
      if (o.typeOfficeID != null &&
          visibleClassDataIDs.isNotEmpty &&
          !visibleClassDataIDs.contains(o.typeOfficeID)) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Search results — tìm theo tên, địa chỉ, phường/xã (client-side, đã cache)
  List<OfficeModel> get searchResults {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return [];
    return allOffices.where((o) {
      if (o.latitude == null ||
          o.longitude == null ||
          o.latitude == 0 ||
          o.longitude == 0) {
        return false;
      }
      final name    = o.officeName.toLowerCase();
      final addr    = (o.officeAddress  ?? '').toLowerCase();
      final religion= (o.religionName   ?? '').toLowerCase();
      final type    = (o.typeOfficeName ?? '').toLowerCase();
      final village = (o.villageName    ?? '').toLowerCase(); // phường/xã
      return name.contains(q)    ||
             addr.contains(q)    ||
             religion.contains(q)||
             type.contains(q)    ||
             village.contains(q);
    }).toList();
  }

  /// WorkUnit của user hiện tại (từ profile cache) — dùng cho chip gợi ý tìm kiếm.
  /// Trả null nếu chưa có cache (lần đầu chưa load profile).
  String? get userWorkUnit {
    try {
      // Dùng AccountController nếu đã khởi tạo; không tạo mới nếu chưa có
      final acCtrl = Get.find<AccountController>();
      final wu = acCtrl.user.value?.workUnit;
      return (wu != null && wu.trim().isNotEmpty) ? wu.trim() : null;
    } catch (_) {
      return null;
    }
  }

  /// Count markers per religion ID
  Map<int, int> get religionMarkerCounts {
    final counts = <int, int>{};
    for (final o in filteredOffices) {
      if (o.religionID != null) {
        counts[o.religionID!] = (counts[o.religionID!] ?? 0) + 1;
      }
    }
    return counts;
  }

  @override
  void onInit() {
    super.onInit();
    _loadMapSettings();
    _loadInitialData();
  }

  // ═══════════════════════════════════════════════════════════════
  // 1. MOUNT — Song song 4 API
  // ═══════════════════════════════════════════════════════════════
  Future<void> _loadInitialData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _fetchOffices(),
        _fetchReligions(),
        _fetchClassData(),
        _fetchBoundary(),
      ]);
    } catch (e) {
      log('GisMapController._loadInitialData failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchOffices() async {
    final list = await _service.getOfficeList();
    allOffices.assignAll(list);
  }

  Future<void> _fetchReligions() async {
    final list = await _service.getReligionListActive();
    religions.assignAll(list);
    // Default: tất cả visible
    visibleReligionIDs.assignAll(list.map((r) => r.religionID));
  }

  Future<void> _fetchClassData() async {
    final list = await _service.getClassDataListActive();
    classDataList.assignAll(list);
    // Default: tất cả visible
    visibleClassDataIDs.assignAll(list.map((c) => c.classDataID));
  }

  Future<void> _fetchBoundary() async {
    final city = await _service.getCityDefault();
    if (city == null) return;
    cityName.value = city.cityName;

    final points = await _service.getCityPoints(city.cityID);
    // Sort theo Order rồi convert sang LatLng
    points.sort((a, b) => a.order.compareTo(b.order));
    final coords = points
        .where((p) => p.latitude != null && p.longitude != null)
        .map((p) => LatLng(p.latitude!, p.longitude!))
        .toList();
    if (coords.length >= 3) {
      boundaryPoints.assignAll(coords);

      // Tính centroid đơn giản (trung bình lat/lng)
      final avgLat =
          coords.map((p) => p.latitude).reduce((a, b) => a + b) / coords.length;
      final avgLng =
          coords.map((p) => p.longitude).reduce((a, b) => a + b) / coords.length;
      boundaryCenter.value = LatLng(avgLat, avgLng);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // RIGHT TOOLBAR ACTIONS
  // ═══════════════════════════════════════════════════════════════
  void zoomIn() {
    final currentZoom = mapController.camera.zoom;
    mapController.move(mapController.camera.center, currentZoom + 1);
  }

  void zoomOut() {
    final currentZoom = mapController.camera.zoom;
    mapController.move(mapController.camera.center, currentZoom - 1);
  }

  void fitBoundary() {
    if (boundaryPoints.isNotEmpty) {
      final bounds = LatLngBounds.fromPoints(boundaryPoints);
      mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(50),
        ),
      );
    } else {
      mapController.move(initialCenter, 13);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // MAP LAYER SETTINGS
  // ═══════════════════════════════════════════════════════════════

  Future<void> _loadMapSettings() async {
    try {
      final raw = await _secStorage.read(key: _kSettings);
      if (raw == null) return;
      final map = jsonDecode(raw) as Map<String, dynamic>;

      // Base layer
      final idx = (map['baseLayer'] as int?) ?? 0;
      if (idx >= 0 && idx < MapBaseLayer.values.length) {
        baseLayer.value = MapBaseLayer.values[idx];
      }

      // POI overlays — chỉ restore danh sách đã bật;
      // dữ liệu thực (points) load khi map ready
      final poiList = (map['poiOverlays'] as List?)?.cast<int>() ?? [];
      poiOverlays.assignAll(
        poiList
            .where((i) => i >= 0 && i < PoiCategory.values.length)
            .map((i) => PoiCategory.values[i]),
      );
    } catch (e) {
      log('GisMapController._loadMapSettings error: $e');
    }
  }

  Future<void> _saveMapSettings() async {
    try {
      await _secStorage.write(
        key: _kSettings,
        value: jsonEncode({
          'baseLayer'   : baseLayer.value.index,
          'poiOverlays' : poiOverlays.map((p) => p.index).toList(),
        }),
      );
    } catch (e) {
      log('GisMapController._saveMapSettings error: $e');
    }
  }

  /// Đổi lớp nền bản đồ và lưu.
  void setBaseLayer(MapBaseLayer layer) {
    if (baseLayer.value == layer) return;
    baseLayer.value = layer;
    _saveMapSettings();
  }

  /// Bật/tắt overlay POI và fetch dữ liệu nếu cần.
  Future<void> togglePoiOverlay(PoiCategory category) async {
    if (poiOverlays.contains(category)) {
      poiOverlays.remove(category);
      poiPoints.remove(category);
    } else {
      poiOverlays.add(category);
      await _fetchPoiForCategory(category);
    }
    _saveMapSettings();
  }

  Future<void> _fetchPoiForCategory(PoiCategory category) async {
    if (poiPoints.containsKey(category)) return; // already cached
    isPoiLoading.value = true;
    try {
      final bounds = mapController.camera.visibleBounds;
      // Mở rộng bounds ~20% để lấy POI ngoài rìa viewport
      final latPad = (bounds.north - bounds.south) * 0.2;
      final lngPad = (bounds.east  - bounds.west)  * 0.2;
      final points = await OverpassService.fetchPoi(
        category: category,
        south: bounds.south - latPad,
        west : bounds.west  - lngPad,
        north: bounds.north + latPad,
        east : bounds.east  + lngPad,
      );
      poiPoints[category] = points;
    } finally {
      isPoiLoading.value = false;
    }
  }

  /// Gọi sau khi map ready — fetch lại POI đã lưu (viewport đã sẵn sàng).
  Future<void> onMapReadyFetchPois() async {
    for (final cat in List.of(poiOverlays)) {
      if (!poiPoints.containsKey(cat)) {
        await _fetchPoiForCategory(cat);
      }
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Lỗi', 'Dịch vụ vị trí đang bị tắt.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Lỗi', 'Quyền truy cập vị trí bị từ chối.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Lỗi',
          'Quyền truy cập vị trí bị từ chối vĩnh viễn. Vui lòng mở cài đặt thiết bị để cấp quyền.');
      return false;
    }

    return true;
  }

  Future<void> goToMyLocation() async {
    try {
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) return;

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );
      
      final currentLoc = LatLng(pos.latitude, pos.longitude);
      userLocation.value = currentLoc;
      mapController.move(currentLoc, 15);
    } catch (e) {
      log('Lỗi lấy vị trí: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 2. MARKER TAP — Dùng data sẵn + song song 3 API phụ
  // ═══════════════════════════════════════════════════════════════
  void onMarkerTap(OfficeModel office) {
    // Di chuyển camera tới cơ sở (offset nhẹ vĩ độ xuống dưới để không bị che bởi popup)
    if (office.latitude != null &&
        office.longitude != null &&
        office.latitude != 0) {
      // Vì bottom sheet che khoảng 50% màn hình dưới, ta dời tâm bản đồ xuống dưới 1 chút
      // bằng cách trừ đi một phần vĩ độ (tùy thuộc vào mức zoom)
      final currentZoom = mapController.camera.zoom;
      final targetZoom = currentZoom < 14.0 ? 15.0 : currentZoom;
      
      // Tính offset xấp xỉ theo mức zoom
      final offset = 0.005 * (15.0 / targetZoom);
      final targetLoc = LatLng(office.latitude! - offset, office.longitude!);
      
      mapController.move(targetLoc, targetZoom);
    }

    // Reset trạng thái cũ
    selectedOffice.value = office;
    officeLeader.value = null;
    showProfileExpanded.value = false;
    officeDetail.value = null;
    bannerImages.clear();
    documents.clear();
    activeEvents.clear();
    events.clear();
    allAlbums.clear();
    albumImages.clear();
    selectedAlbum.value = null;
    routePoints.clear();
    isRouting.value = false;

    // Load popup data song song
    _loadPopupData(office.officeID);
  }

  Future<void> _loadPopupData(int officeID) async {
    isPopupLoading.value = true;
    try {
      await Future.wait([
        _fetchBannerImages(officeID),
        _fetchDocuments(officeID),
        _fetchEventsAndAlbums(officeID),
        _fetchActiveEvents(officeID),
        _fetchLeader(officeID),
      ]);
    } catch (e) {
      log('GisMapController._loadPopupData failed: $e');
    } finally {
      isPopupLoading.value = false;
    }
  }

  Future<void> _fetchActiveEvents(int officeID) async {
    try {
      final list = await _service.getActiveEventsByOffice(officeID);
      activeEvents.assignAll(list);
    } catch (e) {
      activeEvents.clear();
    }
  }

  Future<void> _fetchLeader(int officeID) async {
    try {
      final leader = await _service.getLeaderByOfficeId(officeID);
      officeLeader.value = leader;
    } catch (e) {
      officeLeader.value = null;
    }
  }

  Future<void> _fetchBannerImages(int officeID) async {
    final list =
        await _service.getBannersByType(officeID: officeID, typeBannerID: 1);
    bannerImages.assignAll(list);
  }

  Future<void> _fetchDocuments(int officeID) async {
    final list =
        await _service.getBannersByType(officeID: officeID, typeBannerID: 2);
    // Filter chỉ lấy file không phải ảnh
    documents.assignAll(list.where((b) => b.isDocument));
  }

  Future<void> _fetchEventsAndAlbums(int officeID) async {
    final eventList = await _service.getEventList(officeID);
    events.assignAll(eventList);

    if (eventList.isEmpty) return;

    // Song song gọi albums cho mỗi event
    final albumResults = await Future.wait(
      eventList.map((e) => _service.getEventAlbums(e.eventID)),
    );
    final merged = <EventAlbumModel>[];
    for (final albums in albumResults) {
      merged.addAll(albums);
    }
    allAlbums.assignAll(merged);
  }

  // ═══════════════════════════════════════════════════════════════
  // 3. XEM HỒ SƠ
  // ═══════════════════════════════════════════════════════════════
  Future<void> onViewProfile(int officeID) async {
    isProfileLoading.value = true;
    try {
      final detail = await _service.getOfficeById(officeID);
      officeDetail.value = detail;
      showProfileExpanded.value = true;
    } catch (e) {
      log('GisMapController.onViewProfile failed: $e');
    } finally {
      isProfileLoading.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ALBUM TAP
  // ═══════════════════════════════════════════════════════════════
  Future<void> onAlbumTap(EventAlbumModel album) async {
    selectedAlbum.value = album;
    isAlbumLoading.value = true;
    try {
      final images = await _service.getAlbumImages(album.eventAlbumID);
      albumImages.assignAll(images);
    } catch (e) {
      log('GisMapController.onAlbumTap failed: $e');
    } finally {
      isAlbumLoading.value = false;
    }
  }

  void closeAlbumViewer() {
    selectedAlbum.value = null;
    albumImages.clear();
  }

  // ═══════════════════════════════════════════════════════════════
  // 4. CHỈ ĐƯỜNG — GPS + OSRM
  // ═══════════════════════════════════════════════════════════════
  Future<void> onDirectionTap() async {
    final office = selectedOffice.value;
    if (office == null ||
        office.latitude == null ||
        office.longitude == null) {
      return;
    }

    isRouting.value = true;
    try {
      // Request GPS permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Quyền GPS', 'Vui lòng cấp quyền truy cập vị trí');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Quyền GPS', 'Quyền vị trí bị từ chối vĩnh viễn.\nVào Cài đặt để bật lại.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      userLocation.value = LatLng(pos.latitude, pos.longitude);

      // Get route from OSRM
      final points = await _service.getOsrmRoute(
        fromLat: pos.latitude,
        fromLng: pos.longitude,
        toLat: office.latitude!,
        toLng: office.longitude!,
      );

      routePoints.assignAll(
        points.map((p) => LatLng(p[0], p[1])),
      );
    } catch (e) {
      log('GisMapController.onDirectionTap failed: $e');
      Get.snackbar('Lỗi', 'Không thể lấy vị trí hoặc tuyến đường');
    } finally {
      isRouting.value = false;
    }
  }

  void clearRoute() {
    routePoints.clear();
    userLocation.value = null;
  }

  // ═══════════════════════════════════════════════════════════════
  // SEARCH — Client-side, dữ liệu đã cache
  // ═══════════════════════════════════════════════════════════════
  void openSearch() {
    isSearching.value = true;
    closePopup();
  }

  void clearSearch() {
    searchQuery.value = '';
    isSearching.value = false;
  }

  void onSearchResultTap(OfficeModel office) {
    searchQuery.value = '';
    isSearching.value = false;
    onMarkerTap(office);
  }

  // ═══════════════════════════════════════════════════════════════
  // FILTER TOGGLE — Chỉ show/hide, không gọi API
  // ═══════════════════════════════════════════════════════════════
  void toggleFilterPanel() {
    showFilterPanel.toggle();
  }

  void toggleReligion(int id) {
    if (visibleReligionIDs.contains(id)) {
      visibleReligionIDs.remove(id);
    } else {
      visibleReligionIDs.add(id);
    }
  }

  void toggleClassData(int id) {
    if (visibleClassDataIDs.contains(id)) {
      visibleClassDataIDs.remove(id);
    } else {
      visibleClassDataIDs.add(id);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CLOSE POPUP
  // ═══════════════════════════════════════════════════════════════
  void closePopup() {
    selectedOffice.value = null;
    officeLeader.value = null;
    showProfileExpanded.value = false;
    officeDetail.value = null;
    bannerImages.clear();
    documents.clear();
    activeEvents.clear();
    events.clear();
    allAlbums.clear();
    albumImages.clear();
    selectedAlbum.value = null;
    routePoints.clear();
    isRouting.value = false;
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════

  /// Màu marker theo ReligionID
  static const religionColors = <int, int>{
    1: 0xFFC9A84C, // Phật giáo
    2: 0xFF3B6FA0, // Công giáo
    3: 0xFF9B59B6, // Cao Đài
    4: 0xFFE67E22, // Tín ngưỡng
    5: 0xFFE74C3C, // Hòa Hảo
    6: 0xFF2ECC71, // Islam
  };

  /// Viết tắt ký tự đầu cho marker
  static const religionAbbrev = <int, String>{
    1: 'P', // Phật
    2: 'C', // Công giáo
    3: 'Đ', // Cao Đài
    4: 'T', // Tín ngưỡng
    5: 'H', // Hòa Hảo
    6: 'I', // Islam
  };
}
