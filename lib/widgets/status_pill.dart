import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/values/app_colors.dart';

enum PillKind { emerald, amber, blue, red, slate, gold, ghost }

class StatusPill extends StatelessWidget {
  final PillKind kind;
  final String label;
  final double fontSize;

  const StatusPill({
    super.key,
    required this.kind,
    required this.label,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg, dotColor) = switch (kind) {
      PillKind.emerald => (AppColors.emeraldBg, AppColors.emeraldFg, AppColors.emeraldDot),
      PillKind.amber   => (AppColors.amberBg,   AppColors.amberFg,   AppColors.amberDot),
      PillKind.blue    => (AppColors.blueBg,     AppColors.blueFg,    AppColors.primary),
      PillKind.red     => (AppColors.redBg,      AppColors.redFg,     AppColors.redDot),
      PillKind.slate   => (AppColors.slateBg,    AppColors.slateFg,   AppColors.inkSoft),
      PillKind.gold    => (AppColors.goldPillBg, AppColors.goldPillFg, AppColors.gold),
      PillKind.ghost   => (Colors.black.withValues(alpha: 0.04), AppColors.inkMuted, AppColors.inkSoft),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: kind == PillKind.ghost
            ? Border.all(color: AppColors.hairline)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fg,
              letterSpacing: 0.005,
            ),
          ),
        ],
      ),
    );
  }
}
