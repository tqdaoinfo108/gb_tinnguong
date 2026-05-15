import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Text styles chuẩn toàn app.
/// Sử dụng font Inter từ Google Fonts.
class AppTextStyles {
  AppTextStyles._();

  // ---------------------------------------------------------------------------
  // Headings
  // ---------------------------------------------------------------------------
  static TextStyle get h1 => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get h3 => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get h4 => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  // ---------------------------------------------------------------------------
  // Caption / Label
  // ---------------------------------------------------------------------------
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      );

  // ---------------------------------------------------------------------------
  // Button
  // ---------------------------------------------------------------------------
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.2,
      );

  // ---------------------------------------------------------------------------
  // Design-system styles (match Tin Nguong design specs)
  // ---------------------------------------------------------------------------

  /// Screen-title hero (30 / w700 / ink / -0.025)
  static TextStyle get hero => GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        letterSpacing: -0.025 * 30,
        height: 1.12,
      );

  /// Section heading (16 / w700 / ink)
  static TextStyle get sectionHeading => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        letterSpacing: -0.01 * 16,
      );

  /// Card title (17 / w600 / ink / -0.01)
  static TextStyle get cardTitle => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
        letterSpacing: -0.01 * 17,
      );

  /// Strong body (15 / w600 / ink)
  static TextStyle get bodyStrong => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      );

  /// Caption (13 / w400 / inkSoft) — most common secondary text
  static TextStyle get cap => GoogleFonts.inter(
        fontSize: 13,
        color: AppColors.inkSoft,
      );

  /// Micro label (11 / w600 / inkFaint / 0.04) — group labels above lists
  static TextStyle get microLabel => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.inkFaint,
        letterSpacing: 0.04 * 11,
      );

  /// Chip text (12 / w600)
  static TextStyle get chip => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.inkMuted,
      );
}
