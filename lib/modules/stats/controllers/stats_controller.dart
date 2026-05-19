import 'package:get/get.dart';
import '../../../data/models/dashboard_model.dart';
import '../../../data/services/stats_service.dart';

class StatsController extends GetxController {
  final _service = StatsService();

  // ── State ────────────────────────────────────────────────────────
  final isLoading  = false.obs;
  final hasError   = false.obs;
  final dashboard  = DashboardModel.empty.obs;

  // Period selection
  final typeSearch = 3.obs;   // default: Năm nay

  // Custom date range (typeSearch = 4)
  final customFrom = Rxn<DateTime>();
  final customTo   = Rxn<DateTime>();

  // Derived labels
  String get periodLabel {
    switch (typeSearch.value) {
      case 1: return 'Tháng này';
      case 2: return _quarterLabel();
      case 4: return _customLabel();
      default: return 'Năm ${DateTime.now().year}';
    }
  }

  // ── Lifecycle ────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    load();
  }

  // ── Public API ───────────────────────────────────────────────────
  void setTypeSearch(int ts) {
    typeSearch.value = ts;
    if (ts != 4) load();
    // typeSearch=4 waits for user to pick dates then call loadCustom()
  }

  void loadCustom(DateTime from, DateTime to) {
    customFrom.value = from;
    customTo.value   = to;
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    hasError.value  = false;
    try {
      final range = buildDateRange(typeSearch.value,
          from: customFrom.value, to: customTo.value);
      final result = await _service.getDashboard(
        fromDate:   range['fromDate']!,
        toDate:     range['toDate']!,
        typeSearch: typeSearch.value,
      );
      dashboard.value = result;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  // ── Date range builder ───────────────────────────────────────────
  static Map<String, String> buildDateRange(int typeSearch,
      {DateTime? from, DateTime? to}) {
    final now   = DateTime.now();
    final year  = now.year;
    final month = now.month;

    switch (typeSearch) {
      case 1: // Tháng này
        final lastDay = DateTime(year, month + 1, 0).day;
        return {
          'fromDate': '$year-${_pad(month)}-01',
          'toDate':   '$year-${_pad(month)}-$lastDay',
        };

      case 2: // Quý này
        final q          = (month - 1) ~/ 3;       // 0,1,2,3
        final startMonth = q * 3 + 1;
        final endMonth   = startMonth + 2;
        final lastDay    = DateTime(year, endMonth + 1, 0).day;
        return {
          'fromDate': '$year-${_pad(startMonth)}-01',
          'toDate':   '$year-${_pad(endMonth)}-$lastDay',
        };

      case 3: // Năm nay
        return {'fromDate': '$year-01-01', 'toDate': '$year-12-31'};

      case 4: // Tùy chọn
        final f = from ?? now;
        final t = to   ?? now;
        return {'fromDate': _fmt(f), 'toDate': _fmt(t)};

      default:
        return {'fromDate': '$year-01-01', 'toDate': '$year-12-31'};
    }
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
  static String _fmt(DateTime d) =>
      '${d.year}-${_pad(d.month)}-${_pad(d.day)}';

  String _quarterLabel() {
    final m = DateTime.now().month;
    final q = (m - 1) ~/ 3 + 1;
    return 'Q$q/${DateTime.now().year}';
  }

  String _customLabel() {
    if (customFrom.value == null || customTo.value == null) return 'Tùy chọn';
    final f = customFrom.value!;
    final t = customTo.value!;
    return '${_pad(f.day)}/${_pad(f.month)} – ${_pad(t.day)}/${_pad(t.month)}';
  }
}
