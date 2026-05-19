import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/main_controller.dart';
import '../../../core/values/app_colors.dart';
import '../../home/views/home_screen.dart';
import '../../map/views/map_screen.dart';
import '../../events/views/events_screen.dart';
import '../../news/views/news_screen.dart';
import '../../notifications/views/notifications_screen.dart';
import '../../account/views/account_screen.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Obx(() => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeScreen(),
            MapScreen(),
            EventsScreen(),
            NewsScreen(),
            NotificationsScreen(),
            AccountScreen(),
          ],
        )),
        extendBody: true,
        bottomNavigationBar: Obx(() => _TnTabBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
        )),
      ),
    );
  }
}

class _TnTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _TnTabBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.86),
            border: const Border(top: BorderSide(color: AppColors.hairline)),
          ),
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8 + bottom),
          child: Row(
            children: [
              _Tab(icon: Icons.home_outlined, activeIcon: Icons.home_rounded,
                  label: 'Trang chủ', active: currentIndex == 0, onTap: () => onTap(0)),
              _Tab(icon: Icons.map_outlined, activeIcon: Icons.map_rounded,
                  label: 'Bản đồ', active: currentIndex == 1, onTap: () => onTap(1)),
              _Tab(icon: Icons.event_outlined, activeIcon: Icons.event_rounded,
                  label: 'Sự kiện', active: currentIndex == 2, onTap: () => onTap(2)),
              _Tab(icon: Icons.newspaper_outlined, activeIcon: Icons.newspaper_rounded,
                  label: 'Tin tức', active: currentIndex == 3, onTap: () => onTap(3)),
              _Tab(icon: Icons.notifications_outlined, activeIcon: Icons.notifications_rounded,
                  label: 'Thông báo', active: currentIndex == 4, onTap: () => onTap(4), badge: 3),
              _Tab(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded,
                  label: 'Tài khoản', active: currentIndex == 5, onTap: () => onTap(5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final int badge;
  const _Tab({
    required this.icon, required this.activeIcon,
    required this.label, required this.active,
    required this.onTap, this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      active ? activeIcon : icon,
                      key: ValueKey(active),
                      size: 22,
                      color: active ? AppColors.primary : AppColors.inkFaint,
                    ),
                  ),
                  if (badge > 0)
                    Positioned(
                      right: -6, top: -4,
                      child: Container(
                        width: 16, height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.primary, shape: BoxShape.circle,
                        ),
                        child: Center(child: Text('$badge', style: GoogleFonts.inter(
                          fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white,
                        ))),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColors.primary : AppColors.inkFaint,
                  letterSpacing: 0.01,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
