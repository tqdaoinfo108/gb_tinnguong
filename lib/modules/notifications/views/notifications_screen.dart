import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../data/models/information_model.dart';
import '../../../widgets/circle_icon_button.dart';
import '../../../widgets/filter_chip.dart';
import '../controllers/notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
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
                      Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Thông báo', style: _hero),
                        Text(
                          '${controller.unreadCount} mới · ${controller.items.length} thông báo',
                          style: _cap,
                        ),
                      ])),
                      Row(children: [
                        CircleIconButton(icon: Icons.check_rounded, onTap: controller.markAllRead),
                        const SizedBox(width: 8),
                        const CircleIconButton(icon: Icons.filter_list_rounded),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Filter tabs
                  const FilterChipBar(
                    padding: EdgeInsets.zero,
                    labels: ['Tất cả', 'Quan trọng', 'Thông tin', 'Hệ thống'],
                  ),
                ],
              ),
            ),
          ),

          // Content
          Obx(() {
            if (controller.isLoading.value && controller.items.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
                ),
              );
            }

            if (controller.items.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                  child: Center(child: Text('Chưa có thông báo', style: _cap)),
                ),
              );
            }

            // Group by day
            final today = DateTime.now();
            final todayItems = controller.items.where((e) => _isSameDay(e.dateCreate, today)).toList();
            final yesterdayItems = controller.items
                .where((e) => _isSameDay(e.dateCreate, today.subtract(const Duration(days: 1))))
                .toList();
            final olderItems = controller.items
                .where((e) => !_isSameDay(e.dateCreate, today) && !_isSameDay(e.dateCreate, today.subtract(const Duration(days: 1))))
                .toList();

            return SliverList(
              delegate: SliverChildListDelegate([
                if (todayItems.isNotEmpty) ...[
                  _sectionHeader('HÔM NAY'),
                  ...todayItems.map((e) => _buildCard(e, controller)),
                  const SizedBox(height: 8),
                ],
                if (yesterdayItems.isNotEmpty) ...[
                  _sectionHeader('HÔM QUA'),
                  ...yesterdayItems.map((e) => _buildCard(e, controller)),
                  const SizedBox(height: 8),
                ],
                if (olderItems.isNotEmpty) ...[
                  _sectionHeader('TRƯỚC ĐÓ'),
                  ...olderItems.map((e) => _buildCard(e, controller)),
                ],
                // Fallback: show all if no date grouping worked
                if (todayItems.isEmpty && yesterdayItems.isEmpty && olderItems.isEmpty) ...[
                  _sectionHeader('TẤT CẢ'),
                  ...controller.items.map((e) => _buildCard(e, controller)),
                ],
                const SizedBox(height: 100),
              ]),
            );
          }),
        ],
      ),
    );
  }

  Widget _sectionHeader(String label) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
    child: Text(label, style: GoogleFonts.inter(
      fontSize: 11, fontWeight: FontWeight.w500,
      color: AppColors.inkSoft, letterSpacing: 0.05,
    )),
  );

  Widget _buildCard(InformationModel item, NotificationsController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: _NotifCard(item: item),
    );
  }
}

bool _isSameDay(DateTime? a, DateTime b) {
  if (a == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String _formatTime(DateTime? dt) {
  if (dt == null) return '—';
  final now = DateTime.now();
  if (_isSameDay(dt, now)) return DateFormat('HH:mm').format(dt);
  if (_isSameDay(dt, now.subtract(const Duration(days: 1)))) return 'Hôm qua';
  return DateFormat('dd/MM').format(dt);
}

enum _NotifKind { alert, info, ok, system }

_NotifKind _kindFromLevel(int? level) {
  switch (level) {
    case 1: return _NotifKind.info;
    case 2: return _NotifKind.alert;
    case 3: return _NotifKind.ok;
    default: return _NotifKind.system;
  }
}

class _NotifCard extends StatelessWidget {
  final InformationModel item;
  const _NotifCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final kind = _kindFromLevel(item.levelID);
    final (bg, fg, icon) = switch (kind) {
      _NotifKind.alert  => (AppColors.amberBg,   AppColors.amberDot,   Icons.warning_amber_rounded),
      _NotifKind.info   => (AppColors.blueBg,     AppColors.primary,    Icons.notifications_outlined),
      _NotifKind.ok     => (AppColors.emeraldBg,  AppColors.emeraldDot, Icons.check_circle_outline_rounded),
      _NotifKind.system => (AppColors.slateBg,    AppColors.inkMuted,   Icons.settings_outlined),
    };
    final unread = !item.isRead;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unread ? AppColors.canvas : AppColors.canvas.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unread ? AppColors.primary.withValues(alpha: 0.25) : AppColors.hairline,
        ),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(11)),
                child: Icon(icon, size: 18, color: fg),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(child: Text(item.title, style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink,
                      ))),
                      const SizedBox(width: 8),
                      Text(_formatTime(item.dateCreate), style: GoogleFonts.inter(
                        fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.inkFaint,
                      )),
                    ],
                  ),
                  if (item.shortDescription != null && item.shortDescription!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(item.shortDescription!, style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.inkSoft, height: 1.4,
                    )),
                  ],
                  if (item.senderName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${item.senderName ?? ''}${item.senderRole != null ? ' · ${item.senderRole}' : ''}',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.inkFaint),
                    ),
                  ],
                ],
              )),
            ],
          ),
          if (unread)
            Positioned(
              left: -6, top: 0, bottom: 0,
              child: Center(child: Container(
                width: 6, height: 6,
                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              )),
            ),
        ],
      ),
    );
  }
}

final _hero = AppTextStyles.hero;
final _cap = AppTextStyles.cap;
