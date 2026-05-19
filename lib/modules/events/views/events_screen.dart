import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// intl not needed — using local month helper instead
import '../../../core/utils/religion_palette.dart' as palette;
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/dropdown_models.dart';
import '../../../data/models/office_model.dart';
import '../../../widgets/filter_chip.dart';
import '../../../widgets/status_pill.dart';
import '../controllers/events_controller.dart';
import 'event_detail_screen.dart';

// ────────────────────────────────────────────────────────────────
// EventsScreen alias — used by main_view.dart
// ────────────────────────────────────────────────────────────────
typedef EventsScreen = EventsPage;
class EventsPage extends StatefulWidget {
  const EventsPage({super.key});
  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool _showCalendar = false;

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<EventsController>();
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.filteredEvents.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
          );
        }
        return _showCalendar
            ? _CalendarBody(ctrl: ctrl, onToggle: () => setState(() => _showCalendar = false))
            : _ListBody(ctrl: ctrl, onToggle: () => setState(() => _showCalendar = true));
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _openForm(context, ctrl, null),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

// ─── List Body ─────────────────────────────────────────────────
class _ListBody extends StatelessWidget {
  final EventsController ctrl;
  final VoidCallback onToggle;
  const _ListBody({required this.ctrl, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Header ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, top + 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Sự kiện', style: _hero),
                      Text('Lễ hội & hoạt động · ${ctrl.total.value} sự kiện', style: _cap),
                    ])),
                    _ToggleSegment(showCalendar: false, onToggle: onToggle),
                  ],
                ),
                const SizedBox(height: 14),
                // Search bar
                _SearchBar(ctrl: ctrl),
              ],
            ),
          ),
        ),

        // ── Status filter chips ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Obx(() => FilterChipBar(
              labels: const ['Tất cả', 'Sắp diễn ra', 'Đang diễn ra', 'Hoàn thành', 'Đã hủy'],
              activeIndex: _statusFilterIndex(ctrl.selectedStatusID.value),
              onChanged: (i) => ctrl.selectedStatusID.value = _statusIDFromIndex(i),
            )),
          ),
        ),

        // ── Permit filter ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Obx(() => Row(children: [
              TypeChip(
                label: 'Tất cả',
                active: ctrl.permitFilter.value == 0,
                onTap: () => ctrl.permitFilter.value = 0,
              ),
              const SizedBox(width: 8),
              TypeChip(
                label: 'Đã cấp phép',
                active: ctrl.permitFilter.value == 1,
                onTap: () => ctrl.permitFilter.value = 1,
              ),
              const SizedBox(width: 8),
              TypeChip(
                label: 'Chưa có phép',
                active: ctrl.permitFilter.value == 2,
                onTap: () => ctrl.permitFilter.value = 2,
              ),
            ])),
          ),
        ),

        // ── Alert banner ──
        Obx(() {
          final alerts = ctrl.alertEvents;
          if (alerts.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: _AlertBanner(events: alerts),
            ),
          );
        }),

        // ── KPI strip ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Obx(() => Row(children: [
              _KpiTile(label: 'Tổng', value: '${ctrl.total.value}'),
              const SizedBox(width: 8),
              _KpiTile(label: 'Sắp tới', value: '${ctrl.countUpcoming}'),
              const SizedBox(width: 8),
              _KpiTile(label: 'Đã phép', value: '${ctrl.countPermit}', tone: PillKind.emerald),
              const SizedBox(width: 8),
              _KpiTile(label: 'Chưa phép', value: '${ctrl.countNoPermit}', tone: PillKind.amber),
            ])),
          ),
        ),

        // ── Event cards ──
        Obx(() {
          final list = ctrl.filteredEvents;
          if (list.isEmpty && !ctrl.isLoading.value) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Center(child: Text('Không có sự kiện', style: _cap)),
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  if (i.isOdd) return const SizedBox(height: 12);
                  final event = list[i ~/ 2];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EventDetailScreen(event: event),
                      ),
                    ),
                    child: _EventCard(
                      event: event,
                      onEdit: () => _openForm(context, ctrl, event),
                      onDelete: () => ctrl.deleteEvent(event),
                    ),
                  );
                },
                childCount: list.length * 2 - 1,
              ),
            ),
          );
        }),

        // ── Load more ──
        Obx(() => ctrl.hasMore.value
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: OutlinedButton(
                    onPressed: ctrl.loadMore,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: ctrl.isLoading.value
                        ? const SizedBox(height: 20, width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                        : Text('Xem thêm', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  ),
                ),
              )
            : const SliverToBoxAdapter(child: SizedBox.shrink())),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

// ─── Calendar Body ─────────────────────────────────────────────
class _CalendarBody extends StatelessWidget {
  final EventsController ctrl;
  final VoidCallback onToggle;
  const _CalendarBody({required this.ctrl, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Obx(() {
      final monthMap = ctrl.byMonth;
      final selectedM = ctrl.selectedCalMonth.value > 0
          ? ctrl.selectedCalMonth.value
          : (monthMap.isNotEmpty ? monthMap.keys.first : DateTime.now().month);
      final noPermitCount = ctrl.countNoPermit;

      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, top + 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Lịch 2026', style: _hero),
                        Text(
                          'Tổng ${ctrl.total.value} sự kiện${noPermitCount > 0 ? ' · $noPermitCount chưa phép' : ''}',
                          style: _cap,
                        ),
                      ]),
                      _ToggleSegment(showCalendar: true, onToggle: onToggle),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Month grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8,
                childAspectRatio: 1.15,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final month = i + 1;
                  final mEvents = monthMap[month] ?? [];
                  final isSelected = month == selectedM;
                  return GestureDetector(
                    onTap: () => ctrl.selectedCalMonth.value = month,
                    child: _MonthTile(
                      label: 'T$month',
                      events: mEvents,
                      isSelected: isSelected,
                    ),
                  );
                },
                childCount: 12,
              ),
            ),
          ),

          // Month detail
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tháng $selectedM · ${ctrl.calMonthEvents.length} sự kiện',
                    style: GoogleFonts.inter(
                      fontSize: 19, fontWeight: FontWeight.w600,
                      color: AppColors.ink, letterSpacing: -0.015,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (ctrl.calMonthEvents.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: Text('Không có sự kiện trong tháng này', style: _cap)),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.canvas,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [AppColors.cardShadow],
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < ctrl.calMonthEvents.length; i++) ...[
                            if (i > 0) const Divider(color: AppColors.hairline, thickness: 1, height: 1),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EventDetailScreen(event: ctrl.calMonthEvents[i]),
                                ),
                              ),
                              child: _CalEventRow(event: ctrl.calMonthEvents[i]),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      );
    });
  }
}

// ─── Search bar ────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final EventsController ctrl;
  const _SearchBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.parchment2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(children: [
        const Icon(Icons.search_rounded, size: 18, color: AppColors.inkSoft),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.ink),
            decoration: InputDecoration(
              hintText: 'Tìm tên sự kiện, cơ sở…',
              hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.inkFaint),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              fillColor: Colors.transparent,
              filled: false,
            ),
            onChanged: (v) => ctrl.searchKey.value = v,
          ),
        ),
        if (ctrl.searchKey.value.isNotEmpty)
          GestureDetector(
            onTap: () => ctrl.searchKey.value = '',
            child: const Icon(Icons.close_rounded, size: 18, color: AppColors.inkFaint),
          ),
      ]),
    );
  }
}

// ─── Alert banner ──────────────────────────────────────────────
class _AlertBanner extends StatelessWidget {
  final List<EventModel> events;
  const _AlertBanner({required this.events});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          colors: [Color(0xFFFBF1D9), Color(0xFFF7E6BF)],
        ),
        border: Border.all(color: const Color(0xFFECD9A6)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF0C878), borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.warning_amber_rounded, size: 18, color: Color(0xFF735A14)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${events.length} sự kiện sắp diễn ra chưa có giấy phép',
                  style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w600,
                    color: const Color(0xFF735A14),
                  )),
              const SizedBox(height: 4),
              ...events.take(3).map((e) => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '· ${e.eventName}${e.dateStart != null ? " · ${_fmtDayMonth(e.dateStart!)}" : ""}',
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8A6310)),
                ),
              )),
            ],
          )),
        ],
      ),
    );
  }
}

// ─── KPI tile ──────────────────────────────────────────────────
class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final PillKind? tone;
  const _KpiTile({required this.label, required this.value, this.tone});

  @override
  Widget build(BuildContext context) {
    final fg = switch (tone) {
      PillKind.emerald => AppColors.emeraldFg,
      PillKind.amber   => AppColors.amberFg,
      _                => AppColors.ink,
    };
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [AppColors.lightShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: GoogleFonts.inter(
              fontSize: 20, fontWeight: FontWeight.w700,
              color: fg, letterSpacing: -0.02, height: 1.05,
            )),
            const SizedBox(height: 2),
            Text(label.toUpperCase(), style: GoogleFonts.inter(
              fontSize: 9, fontWeight: FontWeight.w500,
              color: AppColors.inkSoft, letterSpacing: 0.04,
            )),
          ],
        ),
      ),
    );
  }
}

// ─── Event card ────────────────────────────────────────────────
class _EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _EventCard({required this.event, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = palette.religionColor(event.religionName);
    final statusKind = _statusKind(event.statusID);
    final hasPermit = event.hasPermit == true;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date block
                Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: const BoxDecoration(
                    color: AppColors.parchment,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19),
                      bottomLeft: Radius.circular(19),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.dateStart != null
                            ? _monthShort(event.dateStart!.month)
                            : '—',
                        style: GoogleFonts.inter(
                          fontSize: 10, fontWeight: FontWeight.w500,
                          color: AppColors.inkSoft, letterSpacing: 0.04,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        event.dateStart != null ? '${event.dateStart!.day}' : '—',
                        style: GoogleFonts.inter(
                          fontSize: 32, fontWeight: FontWeight.w700,
                          color: AppColors.ink, letterSpacing: -0.025, height: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        event.dateStart != null
                            ? _weekdayShort(event.dateStart!.weekday)
                            : '',
                        style: GoogleFonts.inter(
                          fontSize: 9, fontWeight: FontWeight.w500,
                          color: AppColors.inkSoft, letterSpacing: 0.02,
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(color: AppColors.hairline, thickness: 1, width: 1),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(width: 6, height: 6,
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Expanded(child: Text(
                            event.religionName ?? event.typeEventName ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSoft,
                            ),
                          )),
                          // Long-press actions
                          GestureDetector(
                            onTap: () => _showActions(context),
                            child: const Icon(Icons.more_horiz_rounded, size: 18, color: AppColors.inkFaint),
                          ),
                        ]),
                        const SizedBox(height: 4),
                        Text(event.eventName,
                            style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w600,
                              color: AppColors.ink, letterSpacing: -0.01,
                            )),
                        if (event.officeName != null) ...[
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.location_on_outlined, size: 12, color: AppColors.inkSoft),
                            const SizedBox(width: 4),
                            Expanded(child: Text(event.officeName!,
                                style: _cap, maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ]),
                        ],
                        if (event.personJoin != null) ...[
                          const SizedBox(height: 3),
                          Row(children: [
                            const Icon(Icons.people_outline_rounded, size: 12, color: AppColors.inkSoft),
                            const SizedBox(width: 4),
                            Text('~ ${_fmtNum(event.personJoin!)} người', style: _cap),
                          ]),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Footer: permit + status
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.hairline)),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(19),
                bottomRight: Radius.circular(19),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PermitBadge(hasPermit: hasPermit, permitNo: event.permitNo),
                StatusPill(kind: statusKind, label: _statusLabel(event.statusID), fontSize: 11),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 8),
          Container(width: 36, height: 4,
              decoration: BoxDecoration(color: AppColors.hairlineStrong,
                  borderRadius: BorderRadius.circular(999))),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: AppColors.inkMuted),
            title: const Text('Chỉnh sửa'),
            onTap: () { Get.back(); onEdit(); },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded, color: AppColors.redFg),
            title: Text('Xóa sự kiện', style: TextStyle(color: AppColors.redFg)),
            onTap: () { Get.back(); onDelete(); },
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

// ─── Permit badge ──────────────────────────────────────────────
class _PermitBadge extends StatelessWidget {
  final bool hasPermit;
  final String? permitNo;
  const _PermitBadge({required this.hasPermit, this.permitNo});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          hasPermit ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded,
          size: 13,
          color: hasPermit ? AppColors.emeraldFg : AppColors.amberFg,
        ),
        const SizedBox(width: 4),
        Text(
          hasPermit ? (permitNo != null ? 'GP: $permitNo' : 'Đã cấp phép') : 'Chưa có phép',
          style: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w600,
            color: hasPermit ? AppColors.emeraldFg : AppColors.amberFg,
          ),
        ),
      ],
    );
  }
}

// ─── Month tile (calendar) ─────────────────────────────────────
class _MonthTile extends StatelessWidget {
  final String label;
  final List<EventModel> events;
  final bool isSelected;
  const _MonthTile({required this.label, required this.events, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final count = events.length;
    final noPermit = events.where((e) => e.hasPermit != true).length;
    return Container(
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.canvas,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.hairline,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(label, style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.ink,
                letterSpacing: -0.01,
              )),
              Text('$count', style: GoogleFonts.inter(
                fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.inkFaint,
              )),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 3, runSpacing: 3,
            children: events.take(8).map((e) => Container(
              width: 6, height: 6,
              decoration: BoxDecoration(
                color: e.hasPermit == true ? AppColors.primary : AppColors.amberDot,
                shape: BoxShape.circle,
              ),
            )).toList(),
          ),
          if (noPermit > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('$noPermit chưa phép', style: GoogleFonts.inter(
                fontSize: 9, color: AppColors.amberFg, fontWeight: FontWeight.w600,
              )),
            ),
        ],
      ),
    );
  }
}

// ─── Calendar event row ────────────────────────────────────────
class _CalEventRow extends StatelessWidget {
  final EventModel event;
  const _CalEventRow({required this.event});

  @override
  Widget build(BuildContext context) {
    final color = palette.religionColor(event.religionName);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            color: AppColors.parchment, borderRadius: BorderRadius.circular(12),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              event.dateStart != null ? '${event.dateStart!.day}' : '—',
              style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: AppColors.ink, letterSpacing: -0.02, height: 1,
              ),
            ),
            Text(
              event.dateStart != null
                  ? _weekdayShort(event.dateStart!.weekday)
                  : '',
              style: GoogleFonts.inter(
                fontSize: 9, fontWeight: FontWeight.w500,
                color: AppColors.inkSoft, letterSpacing: 0.04,
              ),
            ),
          ]),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.eventName, style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink,
            )),
            if (event.officeName != null)
              Text(event.officeName!, style: _cap, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        )),
        Row(children: [
          Container(width: 6, height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: event.hasPermit == true ? AppColors.emeraldDot : AppColors.amberDot,
              shape: BoxShape.circle,
            ),
          ),
        ]),
      ]),
    );
  }
}

// ─── Toggle segment ────────────────────────────────────────────
class _ToggleSegment extends StatelessWidget {
  final bool showCalendar;
  final VoidCallback onToggle;
  const _ToggleSegment({required this.showCalendar, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _Seg(label: 'Danh sách', active: !showCalendar),
          _Seg(label: 'Lịch năm', active: showCalendar),
        ]),
      ),
    );
  }
}

class _Seg extends StatelessWidget {
  final String label;
  final bool active;
  const _Seg({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        boxShadow: active ? [BoxShadow(
          color: Colors.black.withValues(alpha: 0.06), blurRadius: 3,
        )] : null,
      ),
      child: Text(label, style: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w600,
        color: active ? AppColors.ink : AppColors.inkSoft,
      )),
    );
  }
}

// ─── Form modal ────────────────────────────────────────────────
void _openForm(BuildContext context, EventsController ctrl, EventModel? event) {
  ctrl.openForm(event: event);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _EventFormSheet(ctrl: ctrl),
  );
}

class _EventFormSheet extends StatelessWidget {
  final EventsController ctrl;
  const _EventFormSheet({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final isEdit = ctrl.editingEvent.value != null;

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 10),
          Container(width: 38, height: 5,
              decoration: BoxDecoration(color: AppColors.hairlineStrong,
                  borderRadius: BorderRadius.circular(999))),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(isEdit ? 'Chỉnh sửa sự kiện' : 'Thêm sự kiện',
                    style: GoogleFonts.inter(
                      fontSize: 19, fontWeight: FontWeight.w600,
                      color: AppColors.ink, letterSpacing: -0.015,
                    )),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.parchment2,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(Icons.close_rounded, size: 18, color: AppColors.inkMuted),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Divider(color: AppColors.hairline, height: 1),
          // Body
          Expanded(
            child: Obx(() {
              if (ctrl.formLoading.value && ctrl.typeEvents.isEmpty) {
                return const Center(child: CircularProgressIndicator(
                  color: AppColors.primary, strokeWidth: 2));
              }
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 20, 20, bottom + 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FormField(label: 'Tên sự kiện *', controller: ctrl.fcName,
                        hint: 'Nhập tên sự kiện', textInputAction: TextInputAction.next),
                    const SizedBox(height: 14),
                    _FormDropdown<TypeEventModel>(
                      label: 'Loại hình *',
                      items: ctrl.typeEvents,
                      selected: ctrl.typeEvents
                          .where((t) => t.typeEventID == ctrl.formTypeEventID.value)
                          .firstOrNull,
                      display: (t) => t.typeEventName,
                      onChanged: (t) => ctrl.formTypeEventID.value = t?.typeEventID,
                    ),
                    const SizedBox(height: 14),
                    _FormDropdown<OfficeModel>(
                      label: 'Cơ sở tổ chức *',
                      items: ctrl.offices,
                      selected: ctrl.offices
                          .where((o) => o.officeID == ctrl.formOfficeID.value)
                          .firstOrNull,
                      display: (o) => o.officeName,
                      onChanged: (o) => ctrl.formOfficeID.value = o?.officeID,
                    ),
                    const SizedBox(height: 14),
                    _FormDropdown<VillageModel>(
                      label: 'Khu phố *',
                      items: ctrl.villages,
                      selected: ctrl.villages
                          .where((v) => v.villageID == ctrl.formVillageID.value)
                          .firstOrNull,
                      display: (v) => v.villageName,
                      onChanged: (v) => ctrl.formVillageID.value = v?.villageID,
                    ),
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(child: _FormField(
                          label: 'Ngày bắt đầu *', controller: ctrl.fcDateStart,
                          hint: 'YYYY-MM-DD', keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next)),
                      const SizedBox(width: 12),
                      Expanded(child: _FormField(
                          label: 'Ngày kết thúc', controller: ctrl.fcDateEnd,
                          hint: 'YYYY-MM-DD', keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next)),
                    ]),
                    const SizedBox(height: 14),
                    _FormDropdown<_StatusOption>(
                      label: 'Trạng thái',
                      items: _statusOptions,
                      selected: _statusOptions
                          .where((s) => s.id == ctrl.formStatusID.value)
                          .firstOrNull,
                      display: (s) => s.label,
                      onChanged: (s) => ctrl.formStatusID.value = s?.id ?? 1,
                    ),
                    const SizedBox(height: 14),
                    _FormField(label: 'Số người tham dự', controller: ctrl.fcPerson,
                        hint: 'VD: 500', keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next),
                    const SizedBox(height: 14),
                    _FormField(label: 'Mã hoạt động', controller: ctrl.fcCode,
                        hint: 'VD: HĐ-2026/001', textInputAction: TextInputAction.next),
                    const SizedBox(height: 14),
                    _FormField(label: 'Ghi chú', controller: ctrl.fcDesc,
                        hint: 'Mô tả / ghi chú', maxLines: 3),
                    const SizedBox(height: 14),
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Đang hoạt động', style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink,
                        )),
                        Switch.adaptive(
                          value: ctrl.formIsActivity.value,
                          activeThumbColor: AppColors.primary,
                          activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
                          onChanged: (v) => ctrl.formIsActivity.value = v,
                        ),
                      ],
                    )),
                    const SizedBox(height: 24),
                    Obx(() => ElevatedButton(
                      onPressed: ctrl.formLoading.value
                          ? null
                          : () async {
                              final ok = await ctrl.submitForm();
                              if (ok) Get.back();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 0,
                      ),
                      child: ctrl.formLoading.value
                          ? const SizedBox(height: 20, width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(isEdit ? 'Cập nhật' : 'Thêm mới',
                              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                    )),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Form helpers ──────────────────────────────────────────────
class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  const _FormField({
    required this.label, required this.controller, required this.hint,
    this.maxLines = 1, this.keyboardType, this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w600,
          color: AppColors.inkMuted, letterSpacing: 0.01,
        )),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.ink),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.inkFaint),
            filled: true,
            fillColor: AppColors.parchment2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          ),
        ),
      ],
    );
  }
}

class _FormDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? selected;
  final String Function(T) display;
  final void Function(T?) onChanged;
  const _FormDropdown({
    required this.label, required this.items,
    required this.selected, required this.display, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w600,
          color: AppColors.inkMuted, letterSpacing: 0.01,
        )),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.parchment2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: selected,
              isExpanded: true,
              hint: Text('Chọn...', style: GoogleFonts.inter(
                fontSize: 14, color: AppColors.inkFaint)),
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.ink),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.inkFaint),
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(display(item), overflow: TextOverflow.ellipsis),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────
class _StatusOption {
  final int id;
  final String label;
  const _StatusOption(this.id, this.label);
}

const _statusOptions = [
  _StatusOption(1, 'Sắp diễn ra'),
  _StatusOption(2, 'Đang diễn ra'),
  _StatusOption(3, 'Đã hoàn thành'),
  _StatusOption(4, 'Đã hủy'),
];

PillKind _statusKind(int? id) => switch (id) {
  1 => PillKind.blue,
  2 => PillKind.amber,
  3 => PillKind.emerald,
  4 => PillKind.red,
  _ => PillKind.slate,
};

String _statusLabel(int? id) => switch (id) {
  1 => 'Sắp diễn ra',
  2 => 'Đang diễn ra',
  3 => 'Hoàn thành',
  4 => 'Đã hủy',
  _ => 'Không xác định',
};

int _statusFilterIndex(int statusID) => switch (statusID) {
  -100 => 0,
  1 => 1,
  2 => 2,
  3 => 3,
  4 => 4,
  _ => 0,
};

int _statusIDFromIndex(int i) => switch (i) {
  0 => -100,
  1 => 1,
  2 => 2,
  3 => 3,
  4 => 4,
  _ => -100,
};

String _weekdayShort(int d) => switch (d) {
  1 => 'T2',
  2 => 'T3',
  3 => 'T4',
  4 => 'T5',
  5 => 'T6',
  6 => 'T7',
  7 => 'CN',
  _ => '',
};

String _fmtNum(int n) {
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
  return '$n';
}

String _fmtDayMonth(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

String _monthShort(int m) => switch (m) {
  1  => 'THG 1',
  2  => 'THG 2',
  3  => 'THG 3',
  4  => 'THG 4',
  5  => 'THG 5',
  6  => 'THG 6',
  7  => 'THG 7',
  8  => 'THG 8',
  9  => 'THG 9',
  10 => 'THG 10',
  11 => 'THG 11',
  12 => 'THG 12',
  _  => '',
};

final _hero = AppTextStyles.hero;
final _cap  = AppTextStyles.cap;
