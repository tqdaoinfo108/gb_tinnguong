import 'package:flutter/material.dart';
import '../core/values/app_colors.dart';

/// Unified circular icon button used across screen headers.
///
/// - `tone: light` (default) — white fill, hairline border, ink-muted icon.
///   Used on parchment backgrounds (lists, details, frosted nav bars).
/// - `tone: dark`  — translucent white over a dark hero/header background.
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final CircleIconTone tone;
  final BoxShape shape;
  final double radius;

  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 36,
    this.iconSize = 18,
    this.tone = CircleIconTone.light,
    this.shape = BoxShape.circle,
    this.radius = 12,
  });

  /// 40x40 squircle, frosted-glass style — used inside dark hero headers.
  const CircleIconButton.dark({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 40,
    this.iconSize = 20,
  })  : tone = CircleIconTone.dark,
        shape = BoxShape.rectangle,
        radius = 12;

  @override
  Widget build(BuildContext context) {
    final decoration = tone == CircleIconTone.dark
        ? BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: shape == BoxShape.rectangle
                ? BorderRadius.circular(radius)
                : null,
            shape: shape,
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          )
        : BoxDecoration(
            color: AppColors.canvas,
            borderRadius: shape == BoxShape.rectangle
                ? BorderRadius.circular(radius)
                : null,
            shape: shape,
            border: Border.all(color: AppColors.hairline),
          );

    final iconColor =
        tone == CircleIconTone.dark ? Colors.white : AppColors.inkMuted;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: decoration,
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}

enum CircleIconTone { light, dark }
