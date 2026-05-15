import 'package:intl/intl.dart';

/// Các hàm format số, tiền tệ dùng chung.
class NumberFormatter {
  NumberFormatter._();

  static final NumberFormat _currency = NumberFormat('#,###', 'vi_VN');
  static final NumberFormat _percent  = NumberFormat('##0.#%');

  /// 1.500.000 đ
  static String toCurrency(num? value) {
    if (value == null) return '--';
    return '${_currency.format(value)} đ';
  }

  /// 1.500.000 (không đơn vị)
  static String toNumber(num? value) {
    if (value == null) return '--';
    return _currency.format(value);
  }

  /// 85.5%
  static String toPercent(double? value) {
    if (value == null) return '--';
    return _percent.format(value);
  }

  /// Rút gọn: 1.5M, 500K
  static String toCompact(num? value) {
    if (value == null) return '--';
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toString();
  }

  /// Chuyển chuỗi có dấu phẩy về số
  static double? parseNumber(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return double.parse(raw.replaceAll(',', '').replaceAll('.', ''));
    } catch (_) {
      return null;
    }
  }
}
