import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/values/app_colors.dart';

/// Horizontal scrolling row of toggle chips (e.g. facility types, news topics).
///
/// Renders a single-row `SingleChildScrollView` with proper end-padding,
/// so callers don't have to repeat the asMap/Padding boilerplate.
class FilterChipBar extends StatelessWidget {
  final List<String> labels;
  final int activeIndex;
  final ValueChanged<int>? onChanged;
  final EdgeInsetsGeometry padding;

  const FilterChipBar({
    super.key,
    required this.labels,
    this.activeIndex = 0,
    this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: padding,
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            TypeChip(
              label: labels[i],
              active: i == activeIndex,
              onTap: onChanged == null ? null : () => onChanged!(i),
            ),
          ],
        ],
      ),
    );
  }
}

/// Single toggle chip — pill-shaped, dark fill when active.
class TypeChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const TypeChip({
    super.key,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.ink : AppColors.canvas,
          borderRadius: BorderRadius.circular(999),
          border: active ? null : Border.all(color: AppColors.hairline),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppColors.inkMuted,
          ),
        ),
      ),
    );
  }
}

/// Dropdown-style filter chip with a trailing chevron.
/// Used as a static-looking entry point for filter pickers.
class DropChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const DropChip(this.label, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.inkMuted,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 13, color: AppColors.inkSoft),
          ],
        ),
      ),
    );
  }
}
