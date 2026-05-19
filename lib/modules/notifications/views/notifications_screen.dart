import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../data/models/information_model.dart';
import '../../../widgets/circle_icon_button.dart';
import '../../../widgets/filter_chip.dart';
import '../controllers/notifications_controller.dart';
import 'notification_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NotificationsController>();
    final top  = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, top + 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Thông báo', style: _hero),
                          Text(
                            '${ctrl.unreadCount} mới · ${ctrl.items.length} thông báo',
                            style: _cap,
                          ),
                        ],
                      )),
                      Row(children: [
                        CircleIconButton(
                          icon: Icons.check_rounded,
                          onTap: ctrl.markAllRead,
                        ),
                        const SizedBox(width: 8),
                        const CircleIconButton(icon: Icons.filter_list_rounded),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() => FilterChipBar(
                    padding: EdgeInsets.zero,
                    labels: const ['Tất cả', 'Khẩn cấp', 'Thông thường', 'Thấp'],
                    activeIndex: ctrl.selectedLevel.value,
                    onChanged: (i) => ctrl.selectedLevel.value = i,
                  )),
                ],
              ),
            ),
          ),

          // Content
          Obx(() {
            final filtered = ctrl.filteredItems;
            if (ctrl.isLoading.value && filtered.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary, strokeWidth: 2,
                    ),
                  ),
                ),
              );
            }

            if (filtered.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                  child: Center(child: Text('Chưa có thông báo', style: _cap)),
                ),
              );
            }

            final now       = DateTime.now();
            final yesterday = now.subtract(const Duration(days: 1));
            final todayItems     = filtered.where((e) => _sameDay(e.dateCreate, now)).toList();
            final yesterdayItems = filtered.where((e) => _sameDay(e.dateCreate, yesterday)).toList();
            final olderItems     = filtered
                .where((e) => !_sameDay(e.dateCreate, now) && !_sameDay(e.dateCreate, yesterday))
                .toList();

            return SliverList(
              delegate: SliverChildListDelegate([
                if (todayItems.isNotEmpty) ...[
                  _sectionLabel('HÔM NAY'),
                  ...todayItems.map((e) => _CardWrap(item: e, child: _NotifCard(item: e))),
                  const SizedBox(height: 8),
                ],
                if (yesterdayItems.isNotEmpty) ...[
                  _sectionLabel('HÔM QUA'),
                  ...yesterdayItems.map((e) => _CardWrap(item: e, child: _NotifCard(item: e))),
                  const SizedBox(height: 8),
                ],
                if (olderItems.isNotEmpty) ...[
                  _sectionLabel('TRƯỚC ĐÓ'),
                  ...olderItems.map((e) => _CardWrap(item: e, child: _NotifCard(item: e))),
                ],
                if (todayItems.isEmpty && yesterdayItems.isEmpty && olderItems.isEmpty) ...[
                  _sectionLabel('TẤT CẢ'),
                  ...filtered.map((e) => _CardWrap(item: e, child: _NotifCard(item: e))),
                ],

                // Load more
                if (ctrl.hasMore.value)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: ctrl.isLoading.value ? null : ctrl.loadMore,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.4),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: ctrl.isLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppColors.primary,
                                ),
                              )
                            : const Text('Tải thêm'),
                      ),
                    ),
                  ),

                const SizedBox(height: 100),
              ]),
            );
          }),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

bool _sameDay(DateTime? a, DateTime b) =>
    a != null && a.year == b.year && a.month == b.month && a.day == b.day;

String _fmtTime(DateTime? dt) {
  if (dt == null) return '—';
  final now = DateTime.now();
  if (_sameDay(dt, now)) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
  if (_sameDay(dt, now.subtract(const Duration(days: 1)))) return 'Hôm qua';
  return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
}

Widget _sectionLabel(String label) => Padding(
  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
  child: Text(label, style: GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w500,
    color: AppColors.inkSoft, letterSpacing: 0.05,
  )),
);

class _CardWrap extends StatelessWidget {
  final Widget child;
  final InformationModel item;
  const _CardWrap({required this.child, required this.item});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
    child: GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => NotificationDetailScreen(notification: item),
        ),
      ),
      child: child,
    ),
  );
}

// ── Notification kinds ────────────────────────────────────────────────────────

// 1 = Khẩn cấp  2 = Thông thường  3 = Thấp
enum _Kind { urgent, normal, low, system }

_Kind _kindFromLevel(int? level) => switch (level) {
  1 => _Kind.urgent,
  2 => _Kind.normal,
  3 => _Kind.low,
  _ => _Kind.system,
};

// ── Card ──────────────────────────────────────────────────────────────────────

class _NotifCard extends StatelessWidget {
  final InformationModel item;
  const _NotifCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final kind = _kindFromLevel(item.levelID);
    final (bg, fg, icon) = switch (kind) {
      _Kind.urgent => (AppColors.redBg,      AppColors.redFg,      Icons.warning_rounded),
      _Kind.normal => (AppColors.blueBg,     AppColors.primary,    Icons.notifications_outlined),
      _Kind.low    => (AppColors.slateBg,    AppColors.inkMuted,   Icons.info_outline_rounded),
      _Kind.system => (AppColors.parchment2, AppColors.inkFaint,   Icons.settings_outlined),
    };
    final unread = !item.isRead;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unread ? AppColors.canvas : AppColors.canvas.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unread
              ? AppColors.primary.withValues(alpha: 0.25)
              : AppColors.hairline,
        ),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: bg, borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 18, color: fg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(item.title, style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          )),
                        ),
                        const SizedBox(width: 8),
                        Text(_fmtTime(item.dateCreate), style: GoogleFonts.inter(
                          fontSize: 11, fontWeight: FontWeight.w500,
                          color: AppColors.inkFaint,
                        )),
                      ],
                    ),
                    if (item.shortDescription != null &&
                        item.shortDescription!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(item.shortDescription!, style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.inkSoft, height: 1.4,
                      )),
                    ],
                    if (item.senderName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${item.senderName}'
                        '${item.senderRole != null ? ' · ${item.senderRole}' : ''}',
                        style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.inkFaint,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (unread)
            Positioned(
              left: -6, top: 0, bottom: 0,
              child: Center(child: Container(
                width: 6, height: 6,
                decoration: BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle,
                ),
              )),
            ),
        ],
      ),
    );
  }
}

final _hero = AppTextStyles.hero;
final _cap  = AppTextStyles.cap;
