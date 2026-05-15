import 'package:intl/intl.dart';

/// Các hàm format ngày tháng dùng chung.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _ddMMyyyy     = DateFormat('dd/MM/yyyy');
  static final DateFormat _ddMMyyyyHHmm = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _yyyyMMdd     = DateFormat('yyyy-MM-dd');

  /// 15/05/2025
  static String toDisplay(DateTime? date) {
    if (date == null) return '--';
    return _ddMMyyyy.format(date);
  }

  /// 15/05/2025 08:30
  static String toDisplayWithTime(DateTime? date) {
    if (date == null) return '--';
    return _ddMMyyyyHHmm.format(date);
  }

  /// 2025-05-15 (dùng gửi API)
  static String toApiFormat(DateTime? date) {
    if (date == null) return '';
    return _yyyyMMdd.format(date);
  }

  /// Parse từ string ISO: "2025-05-15T08:30:00"
  static DateTime? fromIso(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateTime.parse(raw).toLocal();
    } catch (_) {
      return null;
    }
  }

  /// Trả về "Hôm nay", "Hôm qua", hoặc ngày bình thường
  static String toRelative(DateTime? date) {
    if (date == null) return '--';
    final now = DateTime.now();
    final diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(date.year, date.month, date.day))
        .inDays;
    if (diff == 0) return 'Hôm nay';
    if (diff == 1) return 'Hôm qua';
    return _ddMMyyyy.format(date);
  }
}
