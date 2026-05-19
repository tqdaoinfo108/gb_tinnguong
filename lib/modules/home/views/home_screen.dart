import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/religion_palette.dart' as palette;
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_text_styles.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/news_model.dart';
import '../../../widgets/network_img.dart';
import '../../../widgets/status_pill.dart';
import '../../events/controllers/events_controller.dart';
import '../../events/views/event_detail_screen.dart';
import '../../main/controllers/main_controller.dart';
import '../../news/controllers/news_controller.dart';
import '../../news/views/news_detail_screen.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final home   = Get.find<HomeController>();
    final events = Get.find<EventsController>();
    final news   = Get.find<NewsController>();

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await Future.wait([
            home.fetchDashboard(),
            events.refreshList(),
            news.refresh(),
          ]);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [

            // ── Hero ───────────────────────────────────────────────
            SliverToBoxAdapter(child: _HeroBlock(home: home, events: events)),

            // ── Alerts ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Obx(() {
                final alerts = events.alertEvents;
                if (alerts.isEmpty) return const SizedBox.shrink();
                return _AlertsSection(alerts: alerts);
              }),
            ),

            // ── Upcoming events ────────────────────────────────────
            SliverToBoxAdapter(
              child: Obx(() {
                final list = events.upcomingEvents.take(5).toList();
                return _UpcomingSection(events: list);
              }),
            ),

            // ── Latest news ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Obx(() {
                final list = news.news.take(3).toList();
                return _NewsSection(items: list);
              }),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

// ─── Hero ──────────────────────────────────────────────────────────────────────

class _HeroBlock extends StatelessWidget {
  final HomeController    home;
  final EventsController  events;
  const _HeroBlock({required this.home, required this.events});

  @override
  Widget build(BuildContext context) {
    final top      = MediaQuery.of(context).padding.top;
    final greeting = _greeting();

    return Container(
      color: AppColors.tileDark,
      child: Stack(
        children: [
          // Radial glow
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.85, -0.9),
                  radius: 0.85,
                  colors: [
                    AppColors.gold.withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, top + 24, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TIN NGƯỠNG · GIS', style: GoogleFonts.inter(
                  fontSize: 11, fontWeight: FontWeight.w500,
                  color: AppColors.goldSoft, letterSpacing: 0.08,
                )),
                const SizedBox(height: 6),
                Text(greeting, style: GoogleFonts.inter(
                  fontSize: 28, fontWeight: FontWeight.w700,
                  color: AppColors.onDark, letterSpacing: -0.02, height: 1.15,
                )),
                const SizedBox(height: 4),
                Text('Phường 5 · Quận Bình Thạnh', style: GoogleFonts.inter(
                  fontSize: 14, color: AppColors.onDarkMuted,
                )),
                const SizedBox(height: 22),

                // KPI mini cards
                Obx(() => Row(children: [
                  Expanded(child: _KpiMini(
                    value: home.isLoading.value
                        ? '—'
                        : '${home.totalFacilities.value}',
                    label: 'Cơ sở',
                    tone: _KpiTone.ok,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _KpiMini(
                    value: '${events.countUpcoming}',
                    label: 'Sắp diễn ra',
                    tone: _KpiTone.info,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _KpiMini(
                    value: home.isLoading.value
                        ? '—'
                        : '${events.alertEvents.length}',
                    label: 'Cần xử lý',
                    tone: events.alertEvents.isNotEmpty
                        ? _KpiTone.warn
                        : _KpiTone.ok,
                  )),
                ])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Chào buổi sáng';
    if (h < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }
}

enum _KpiTone { ok, info, warn }

class _KpiMini extends StatelessWidget {
  final String value, label;
  final _KpiTone tone;
  const _KpiMini({required this.value, required this.label, required this.tone});

  @override
  Widget build(BuildContext context) {
    final labelColor = switch (tone) {
      _KpiTone.ok   => AppColors.goldSoft,
      _KpiTone.info => const Color(0xFFA9C7E3),
      _KpiTone.warn => const Color(0xFFF0C878),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: GoogleFonts.inter(
            fontSize: 24, fontWeight: FontWeight.w700,
            color: AppColors.onDark, letterSpacing: -0.02, height: 1.05,
          )),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w500, color: labelColor,
          )),
        ],
      ),
    );
  }
}

// ─── Alerts section ────────────────────────────────────────────────────────────

class _AlertsSection extends StatelessWidget {
  final List<EventModel> alerts;
  const _AlertsSection({required this.alerts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Cảnh báo', style: _h2),
              Text('${alerts.length} mục', style: GoogleFonts.inter(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: AppColors.amberFg,
              )),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [AppColors.cardShadow],
            ),
            child: Column(
              children: [
                for (int i = 0; i < alerts.take(3).length; i++) ...[
                  if (i > 0)
                    const Divider(
                        color: AppColors.hairline, thickness: 1, height: 1),
                  _AlertRow(event: alerts[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final EventModel event;
  const _AlertRow({required this.event});

  @override
  Widget build(BuildContext context) {
    final dateStr = event.dateStart != null
        ? '${_p(event.dateStart!.day)}/${_p(event.dateStart!.month)}'
            '/${event.dateStart!.year}'
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 7, height: 7,
              decoration: const BoxDecoration(
                  color: AppColors.amberDot, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.eventName, style: _bodyStrong,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  [
                    if (event.officeName != null) event.officeName!,
                    if (dateStr.isNotEmpty) dateStr,
                    'Chưa có phép',
                  ].join(' · '),
                  style: _cap,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              size: 16, color: AppColors.inkFaint),
        ],
      ),
    );
  }
}

// ─── Upcoming events ───────────────────────────────────────────────────────────

class _UpcomingSection extends StatelessWidget {
  final List<EventModel> events;
  const _UpcomingSection({required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sắp diễn ra', style: _h2),
              GestureDetector(
                onTap: () => Get.find<MainController>().changeTab(2),
                child: Text('Tất cả ›', style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (events.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.canvas,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [AppColors.cardShadow],
              ),
              child: Center(child: Text(
                  'Không có sự kiện sắp diễn ra', style: _cap)),
            ),
          )
        else
          SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: events.length,
              separatorBuilder: (_, idx) => const SizedBox(width: 12),
              itemBuilder: (ctx, i) => _EventCardSmall(event: events[i]),
            ),
          ),
      ],
    );
  }
}

class _EventCardSmall extends StatelessWidget {
  final EventModel event;
  const _EventCardSmall({required this.event});

  @override
  Widget build(BuildContext context) {
    final color      = palette.religionColor(event.religionName);
    final hasPermit  = event.hasPermit == true;
    final day        = event.dateStart != null
        ? event.dateStart!.day.toString().padLeft(2, '0')
        : '—';
    final monthLabel = event.dateStart != null
        ? 'THG ${event.dateStart!.month}'
        : '';

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
      ),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [AppColors.cardShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(day, style: GoogleFonts.inter(
                  fontSize: 28, fontWeight: FontWeight.w700,
                  letterSpacing: -0.02, height: 1, color: AppColors.ink,
                )),
                const SizedBox(width: 6),
                Text(monthLabel, style: GoogleFonts.inter(
                  fontSize: 11, fontWeight: FontWeight.w500,
                  color: AppColors.inkSoft, letterSpacing: 0.02,
                )),
              ],
            ),
            const SizedBox(height: 10),
            Text(event.eventName, style: _h3,
                maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            if (event.officeName != null)
              Row(children: [
                Container(width: 6, height: 6,
                    decoration: BoxDecoration(
                        color: color, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Expanded(child: Text(event.officeName!, style: _cap,
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
            const Spacer(),
            StatusPill(
              kind: hasPermit ? PillKind.emerald : PillKind.amber,
              label: hasPermit ? 'Đã cấp phép' : 'Chưa có phép',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── News section ──────────────────────────────────────────────────────────────

class _NewsSection extends StatelessWidget {
  final List<NewsModel> items;
  const _NewsSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tin mới', style: _h2),
              Text('Tất cả ›', style: GoogleFonts.inter(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: AppColors.primary,
              )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.canvas,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [AppColors.cardShadow],
              ),
              child: Center(child: Text('Chưa có tin tức', style: _cap)),
            ),
          )
        else
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [AppColors.cardShadow],
            ),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  if (i > 0)
                    const Divider(
                        color: AppColors.hairline, thickness: 1, height: 1),
                  _NewsRow(item: items[i]),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _NewsRow extends StatelessWidget {
  final NewsModel item;
  const _NewsRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => NewsDetailScreen(news: item)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkImg(
              imagePath: item.imagePath,
              width: 60, height: 60,
              borderRadius: BorderRadius.circular(12),
              fallbackTag: item.title.isNotEmpty
                  ? item.title.substring(0, item.title.length.clamp(0, 3))
                  : '',
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.statusName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: StatusPill(
                          kind: PillKind.blue,
                          label: item.statusName!,
                          fontSize: 10.5),
                    ),
                  Text(item.title, style: _bodyStrong, maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(_fmtDate(item.datePublish), style: _cap),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────────────────────

String _fmtDate(DateTime? dt) {
  if (dt == null) return '';
  return '${_p(dt.day)}/${_p(dt.month)}/${dt.year}';
}

String _p(int n) => n.toString().padLeft(2, '0');

// ─── Text styles ───────────────────────────────────────────────────────────────

final _h2 = GoogleFonts.inter(
  fontSize: 19, fontWeight: FontWeight.w600,
  color: AppColors.ink, letterSpacing: -0.015,
);
final _h3 = GoogleFonts.inter(
  fontSize: 16, fontWeight: FontWeight.w600,
  color: AppColors.ink, letterSpacing: -0.01,
);
final _bodyStrong = AppTextStyles.bodyStrong;
final _cap        = AppTextStyles.cap;
