import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/dropdown_models.dart';
import '../../../data/models/office_model.dart';
import '../../../data/services/event_service.dart';

class EventsController extends GetxController {
  final _svc = EventService();

  // ── List state ────────────────────────────────────────────────
  final isLoading = false.obs;
  final events = <EventModel>[].obs;
  final total = 0.obs;
  final page = 1.obs;
  final limit = 20;
  final hasMore = true.obs;

  // ── Filters ───────────────────────────────────────────────────
  final searchKey = ''.obs;
  final selectedStatusID = (-100).obs;
  final permitFilter = 0.obs; // 0=all 1=hasPermit 2=noPermit (client-side)

  // ── Computed (client-side from current page) ──────────────────
  List<EventModel> get filteredEvents {
    final src = events;
    if (permitFilter.value == 1) return src.where((e) => e.hasPermit == true).toList();
    if (permitFilter.value == 2) return src.where((e) => e.hasPermit != true).toList();
    return src;
  }

  List<EventModel> get alertEvents =>
      events.where((e) => e.statusID == 1 && e.hasPermit != true).toList();

  int get countUpcoming => events.where((e) => e.statusID == 1).length;
  int get countPermit   => events.where((e) => e.hasPermit == true).length;
  int get countNoPermit => events.where((e) => e.hasPermit != true).length;

  // ── Calendar: group by month ──────────────────────────────────
  Map<int, List<EventModel>> get byMonth {
    final map = <int, List<EventModel>>{};
    for (final e in events) {
      final m = e.dateStart?.month;
      if (m != null) map.putIfAbsent(m, () => []).add(e);
    }
    return map;
  }

  // ── Selected calendar month ───────────────────────────────────
  final selectedCalMonth = 0.obs; // 0 = auto (first month with events or current)

  List<EventModel> get calMonthEvents {
    final m = selectedCalMonth.value > 0
        ? selectedCalMonth.value
        : (byMonth.isNotEmpty ? byMonth.keys.first : DateTime.now().month);
    return byMonth[m] ?? [];
  }

  // ── Form / Edit state ─────────────────────────────────────────
  final formLoading = false.obs;
  final typeEvents = <TypeEventModel>[].obs;
  final villages = <VillageModel>[].obs;
  final offices = <OfficeModel>[].obs;

  // Form field controllers
  final fcName     = TextEditingController();
  final fcCode     = TextEditingController();
  final fcPerson   = TextEditingController();
  final fcDesc     = TextEditingController();
  final fcDateStart = TextEditingController();
  final fcDateEnd   = TextEditingController();

  final formTypeEventID = Rxn<int>();
  final formVillageID   = Rxn<int>();
  final formOfficeID    = Rxn<int>();
  final formStatusID    = 1.obs;
  final formIsActivity  = true.obs;

  // null = adding new; non-null = editing
  final editingEvent = Rxn<EventModel>();

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
    debounce(searchKey, (_) => _resetAndFetch(), time: const Duration(milliseconds: 400));
    ever(selectedStatusID, (_) => _resetAndFetch());
  }

  @override
  void onClose() {
    fcName.dispose();
    fcCode.dispose();
    fcPerson.dispose();
    fcDesc.dispose();
    fcDateStart.dispose();
    fcDateEnd.dispose();
    super.onClose();
  }

  // ── Fetch ─────────────────────────────────────────────────────
  void _resetAndFetch() {
    page.value = 1;
    hasMore.value = true;
    fetchEvents();
  }

  Future<void> fetchEvents({bool append = false}) async {
    if (!append) page.value = 1;
    isLoading.value = true;
    try {
      final result = await _svc.getList(
        key: searchKey.value,
        statusID: selectedStatusID.value,
        page: page.value,
        limit: limit,
      );
      if (append) {
        events.addAll(result.items);
      } else {
        events.value = result.items;
      }
      total.value = result.total;
      hasMore.value = result.items.length >= limit;
    } catch (e) {
      log('fetchEvents error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadMore() {
    if (!isLoading.value && hasMore.value) {
      page.value++;
      fetchEvents(append: true);
    }
  }

  Future<void> refreshList() => fetchEvents();

  // ── Form open ─────────────────────────────────────────────────
  Future<void> openForm({EventModel? event}) async {
    editingEvent.value = event;
    _fillForm(event);
    formLoading.value = true;

    // Load dropdowns in parallel
    try {
      final results = await Future.wait([
        _svc.getTypeEvents(),
        _svc.getVillages(),
        _svc.getOffices(),
      ]);
      typeEvents.value = results[0] as List<TypeEventModel>;
      villages.value  = results[1] as List<VillageModel>;
      offices.value   = results[2] as List<OfficeModel>;
    } catch (e) {
      log('openForm dropdowns error: $e');
    } finally {
      formLoading.value = false;
    }
  }

  void _fillForm(EventModel? e) {
    fcName.text       = e?.eventName ?? '';
    fcCode.text       = e?.codeActivity ?? '';
    fcPerson.text     = e?.personJoin?.toString() ?? '';
    fcDesc.text       = e?.description ?? '';
    fcDateStart.text  = _fmtDate(e?.dateStart);
    fcDateEnd.text    = _fmtDate(e?.dateEnd);
    formTypeEventID.value = e?.typeEventID;
    formOfficeID.value    = e?.officeID;
    formVillageID.value   = null; // VillageName only, no ID in list response
    formStatusID.value    = e?.statusID ?? 1;
    formIsActivity.value  = e?.isActivity ?? true;
  }

  String _fmtDate(DateTime? d) =>
      d == null ? '' : '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';

  // ── Submit ────────────────────────────────────────────────────
  Future<bool> submitForm() async {
    if (fcName.text.trim().isEmpty) {
      Get.snackbar('Thiếu thông tin', 'Vui lòng nhập tên sự kiện',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    final dateStart = _parseDate(fcDateStart.text);
    if (dateStart == null) {
      Get.snackbar('Thiếu thông tin', 'Vui lòng chọn ngày bắt đầu',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    formLoading.value = true;
    try {
      final payload = <String, dynamic>{
        'EventName':    fcName.text.trim(),
        'TypeEventID':  formTypeEventID.value,
        'OfficeID':     formOfficeID.value,
        'lstVillageID': formVillageID.value != null ? [formVillageID.value] : [],
        'DateStart':    '${fcDateStart.text}T00:00:00',
        'DateEnd':      fcDateEnd.text.isNotEmpty ? '${fcDateEnd.text}T00:00:00' : null,
        'StatusID':     formStatusID.value,
        'PersonJoin':   int.tryParse(fcPerson.text),
        'Description':  fcDesc.text.trim(),
        'IsActivity':   formIsActivity.value,
        'CodeActivity': fcCode.text.trim(),
      };

      if (editingEvent.value != null) {
        payload['EventID'] = editingEvent.value!.eventID;
        await _svc.update(payload);
      } else {
        await _svc.create(payload);
      }

      Get.snackbar('Thành công',
          editingEvent.value != null ? 'Đã cập nhật sự kiện' : 'Đã thêm sự kiện mới',
          snackPosition: SnackPosition.BOTTOM);
      await refreshList();
      return true;
    } catch (e) {
      log('submitForm error: $e');
      Get.snackbar('Lỗi', 'Không thể lưu sự kiện. Vui lòng thử lại.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      formLoading.value = false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────
  Future<void> deleteEvent(EventModel event) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Xóa sự kiện "${event.eventName}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _svc.delete(event.eventID);
      Get.snackbar('Đã xóa', 'Sự kiện đã được xóa', snackPosition: SnackPosition.BOTTOM);
      await refreshList();
    } catch (e) {
      log('deleteEvent error: $e');
      Get.snackbar('Lỗi', 'Không thể xóa sự kiện', snackPosition: SnackPosition.BOTTOM);
    }
  }

  DateTime? _parseDate(String s) {
    if (s.isEmpty) return null;
    return DateTime.tryParse(s);
  }
}
