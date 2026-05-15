/// Model cho KPI summary card trên dashboard.
class KpiSummary {
  final String title;
  final String value;
  final String unit;
  final String description;
  final String? trend; // "+0.2% so với tháng trước"
  final bool isTrendPositive;
  final KpiIconType iconType;

  const KpiSummary({
    required this.title,
    required this.value,
    this.unit = '',
    required this.description,
    this.trend,
    this.isTrendPositive = true,
    required this.iconType,
  });
}

enum KpiIconType { project, staff, meeting, resident }

/// Model cho một cuộc họp.
class MeetingItem {
  final String time;
  final String title;
  final String location;
  final String? tag; // "Sắp tới", etc.
  final bool isUrgent;

  const MeetingItem({
    required this.time,
    required this.title,
    required this.location,
    this.tag,
    this.isUrgent = false,
  });
}

/// Model cho alert banner (công việc quá hạn, v.v.).
class AlertInfo {
  final int count;
  final String label;
  final String description;

  const AlertInfo({
    required this.count,
    required this.label,
    required this.description,
  });
}

/// Model cho AI Insight suggestion.
class AiInsight {
  final String content;
  final String actionLabel;

  const AiInsight({
    required this.content,
    required this.actionLabel,
  });
}

/// Model cho dữ liệu biểu đồ hiệu suất.
class ChartDataPoint {
  final String label;
  final double value;

  const ChartDataPoint({required this.label, required this.value});
}
