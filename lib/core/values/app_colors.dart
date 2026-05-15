import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF3B6FA0);
  static const Color primaryPress = Color(0xFF2F5B85);
  static const Color primaryOnDark = Color(0xFF6EA8D6);

  // Gold accent (reserved for small highlights)
  static const Color gold = Color(0xFFC9A84C);
  static const Color goldSoft = Color(0xFFE9D999);

  // Surfaces
  static const Color canvas = Color(0xFFFFFFFF);
  static const Color parchment = Color(0xFFF8F7F3);   // lighter warm white
  static const Color parchment2 = Color(0xFFEEEBE2);  // slightly lighter
  static const Color tileDark = Color(0xFF1E2D3D);
  static const Color tileDark2 = Color(0xFF243345);

  // Ink
  static const Color ink = Color(0xFF1A2636);
  static const Color inkMuted = Color(0xFF445566);
  static const Color inkSoft = Color(0xFF637080);
  static const Color inkFaint = Color(0xFF96A3B0);
  static const Color onDark = Color(0xFFFFFFFF);
  static const Color onDarkMuted = Color(0xFFC8D1DC);

  // Hairlines — warm-neutral, subtle
  static const Color hairline = Color(0xFFE4E1D8);
  static const Color hairlineStrong = Color(0xFFCECBC0);

  // Status — emerald
  static const Color emeraldBg = Color(0xFFE4F3EC);
  static const Color emeraldFg = Color(0xFF196B43);
  static const Color emeraldDot = Color(0xFF28895A);

  // Status — amber
  static const Color amberBg = Color(0xFFFAF0D8);
  static const Color amberFg = Color(0xFF87600E);
  static const Color amberDot = Color(0xFFB5840A);

  // Status — blue
  static const Color blueBg = Color(0xFFE3EBF5);
  static const Color blueFg = Color(0xFF285882);

  // Status — red
  static const Color redBg = Color(0xFFF5E3E1);
  static const Color redFg = Color(0xFF872721);
  static const Color redDot = Color(0xFFAE3127);

  // Status — slate
  static const Color slateBg = Color(0xFFECE9E1);
  static const Color slateFg = Color(0xFF4B5B6E);

  // Gold pill
  static const Color goldPillBg = Color(0xFFFAF0D6);
  static const Color goldPillFg = Color(0xFF6E5512);

  // Map background
  static const Color mapBg = Color(0xFFE8E3D3);

  // Religion palette
  static const Color buddhism  = Color(0xFFC9A84C);
  static const Color catholic  = Color(0xFF5A8AAE);
  static const Color protestant = Color(0xFF7A9B6E);
  static const Color caodai    = Color(0xFFC87B3A);
  static const Color hoahao    = Color(0xFFB56A8A);
  static const Color islam     = Color(0xFF3B6FA0);
  static const Color folk      = Color(0xFF8A6E4A);

  // Shadows
  static BoxShadow get cardShadow => BoxShadow(
    color: const Color(0xFF1A2636).withValues(alpha: 0.07),
    blurRadius: 14,
    offset: const Offset(0, 3),
  );
  static BoxShadow get cardShadowStrong => BoxShadow(
    color: const Color(0xFF1A2636).withValues(alpha: 0.12),
    blurRadius: 22,
    offset: const Offset(0, 6),
  );
  static BoxShadow get lightShadow => BoxShadow(
    color: const Color(0xFF1A2636).withValues(alpha: 0.05),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );
  static BoxShadow get mediumShadow => BoxShadow(
    color: const Color(0xFF1A2636).withValues(alpha: 0.10),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );

  // Backward-compat aliases
  static const Color primaryBlue = primary;
  static const Color primaryBlueDark = primaryPress;
  static const Color primaryBlueLight = blueBg;
  static const Color secondaryGold = gold;
  static const Color successGreen = emeraldFg;
  static const Color successLight = emeraldBg;
  static const Color alertRed = redFg;
  static const Color alertRedLight = redBg;
  static const Color warningYellow = amberFg;
  static const Color warningLight = amberBg;
  static const Color neutralBackground = parchment;
  static const Color cardWhite = canvas;
  static const Color divider = hairline;
  static const Color textPrimary = ink;
  static const Color textSecondary = inkSoft;
  static const Color textDisabled = inkFaint;
  static const Color textOnPrimary = onDark;
}
