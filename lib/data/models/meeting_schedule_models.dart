/// Model cho một cuộc họp trong màn hình lịch họp.
class MeetingScheduleItem {
  final String time;
  final String title;
  final String location;
  final String duration;
  final String? platform;
  final String? attendeeSummary;
  final String? organizer;
  final String? statusLabel;
  final bool isHighlighted;

  const MeetingScheduleItem({
    required this.time,
    required this.title,
    required this.location,
    required this.duration,
    this.platform,
    this.attendeeSummary,
    this.organizer,
    this.statusLabel,
    this.isHighlighted = false,
  });
}

/// Group cuộc họp theo mốc ngày.
class MeetingScheduleSection {
  final String title;
  final String subtitle;
  final List<MeetingScheduleItem> meetings;

  const MeetingScheduleSection({
    required this.title,
    required this.subtitle,
    required this.meetings,
  });
}
