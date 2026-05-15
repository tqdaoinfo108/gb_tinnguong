import 'package:flutter/material.dart';
import '../core/values/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onHomeTap;
  final VoidCallback onTasksTap;
  final VoidCallback onChatTap;
  final VoidCallback onProfileTap;

  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onHomeTap,
    required this.onTasksTap,
    required this.onChatTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvas,
        border: const Border(
          top: BorderSide(color: AppColors.hairline, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Tổng quát',
                isSelected: selectedIndex == 0,
                onTap: onHomeTap,
              ),
              _NavItem(
                icon: Icons.account_balance_rounded,
                label: 'Cơ sở',
                isSelected: selectedIndex == 1,
                onTap: onTasksTap,
              ),
              _NavItem(
                icon: Icons.map_rounded,
                label: 'Bản đồ',
                isSelected: selectedIndex == 2,
                onTap: onChatTap,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Cá nhân',
                isSelected: selectedIndex == 3,
                onTap: onProfileTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.inkFaint;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: isSelected
                  ? BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    )
                  : null,
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
                letterSpacing: 0.01,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
