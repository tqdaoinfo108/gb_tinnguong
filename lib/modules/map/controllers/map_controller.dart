import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/services/map_service.dart';
import '../../../data/models/office_model.dart';
import '../../../data/models/religion_model.dart';
import '../../../data/models/class_data_model.dart';
import '../../../data/models/banner_model.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/event_album_model.dart';
import 'package:flutter_map/flutter_map.dart';

class GisMapController extends GetxController {
  final _service = MapService();
  final mapController = MapController();

  // ── Map center — HCMC default ──
  final initialCenter = const LatLng(10.7769, 106.7009);
  final zoom = 13.0.obs;

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
  final selectedOffice = Rxn<OfficeModel>();
  final bannerImages = <BannerModel>[].obs;
  final documents = <BannerModel>[].obs;
  final events = <EventModel>[].obs;
  final allAlbums = <EventAlbumModel>[].obs;
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

  /// Search results — tìm theo tên hoặc địa chỉ (client-side, dữ liệu đã cache)
  List<OfficeModel> get searchResults {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return [];
    return allOffices.where((o) {
      // Must have valid coordinates
      if (o.latitude == null ||
          o.longitude == null ||
          o.latitude == 0 ||
          o.longitude == 0) {
        return false;
      }
      final name = o.officeName.toLowerCase();
      final addr = (o.officeAddress ?? '').toLowerCase();
      final religion = (o.religionName ?? '').toLowerCase();
      final type = (o.typeOfficeName ?? '').toLowerCase();
      return name.contains(q) ||
          addr.contains(q) ||
          religion.contains(q) ||
          type.contains(q);
    }).toList();
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
    showProfileExpanded.value = false;
    officeDetail.value = null;
    bannerImages.clear();
    documents.clear();
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
      ]);
    } catch (e) {
      log('GisMapController._loadPopupData failed: $e');
    } finally {
      isPopupLoading.value = false;
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
    showProfileExpanded.value = false;
    officeDetail.value = null;
    bannerImages.clear();
    documents.clear();
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
