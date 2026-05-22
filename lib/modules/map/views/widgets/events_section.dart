import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../data/models/event_model.dart';
import '../../../events/views/event_detail_screen.dart';
import '../../controllers/map_controller.dart';

/// Danh sách sự kiện trong năm — hiển thị phía trên Album ảnh trong popup bản đồ.
class EventsSection extends GetView<GisMapController> {
  const EventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final events = controller.activeEvents;
      if (events.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 14, 0, 8),
            child: Row(
              children: [
                const Icon(Icons.event_outlined,
                    size: 16, color: AppColors.inkSoft),
                const SizedBox(width: 6),
                Text(
                  'Sự kiện trong năm (${events.length})',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),

          // Danh sách
          Container(
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.hairline),
              boxShadow: [AppColors.lightShadow],
            ),
            child: Column(
              children: events.asMap().entries.map((e) {
                final isLast = e.key == events.length - 1;
                return Column(
                  children: [
                    _EventRow(event: e.value),
                    if (!isLast)
                      const Padding(
                        padding: EdgeInsets.only(left: 52),
                        child: Divider(height: 1, color: AppColors.hairline),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }
}

// ── Row mỗi sự kiện ───────────────────────────────────────────────

class _EventRow extends StatelessWidget {
  final EventModel event;
  const _EventRow({required this.event});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, dot) = _statusColors(event.statusID);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.to(
          () => EventDetailScreen(event: event),
          transition: Transition.cupertino,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date block
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.parchment,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  event.dateStart != null
                      ? event.dateStart!.day.toString().padLeft(2, '0')
                      : '—',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    height: 1,
                  ),
                ),
                Text(
                  event.dateStart != null
                      ? 'T${event.dateStart!.month}'
                      : '',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: AppColors.inkSoft,
                    letterSpacing: 0.02,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.eventName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Loại hình
                    if (event.typeEventName != null) ...[
                      Text(
                        event.typeEventName!,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.inkFaint,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: AppColors.inkFaint,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    // Ngày kết thúc
                    if (event.dateEnd != null)
                      Text(
                        'đến ${_fmtDate(event.dateEnd!)}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.inkFaint,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Status pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5, height: 5,
                  decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                ),
                const SizedBox(width: 4),
                Text(
                  _statusLabel(event.statusID),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ],
          ),
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

  String _statusLabel(int? id) => switch (id) {
    1 => 'Sắp tới',
    2 => 'Đang diễn ra',
    3 => 'Hoàn thành',
    4 => 'Đã hủy',
    _ => 'Không rõ',
  };

  (Color bg, Color fg, Color dot) _statusColors(int? id) => switch (id) {
    1 => (AppColors.blueBg,    AppColors.primary,    AppColors.primary),
    2 => (AppColors.amberBg,   AppColors.amberFg,    AppColors.amberDot),
    3 => (AppColors.emeraldBg, AppColors.emeraldFg,  AppColors.emeraldDot),
    4 => (AppColors.slateBg,   AppColors.inkFaint,   AppColors.inkFaint),
    _ => (AppColors.slateBg,   AppColors.inkFaint,   AppColors.inkFaint),
  };
}
