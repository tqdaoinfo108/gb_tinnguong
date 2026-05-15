import 'package:flutter/material.dart';
import '../values/app_colors.dart';

/// Map a religion name to its accent colour.
/// Falls back to [AppColors.folk] for unknown / null values.
Color religionColor(String? name) {
  switch (name?.toLowerCase().trim()) {
    case 'phật giáo':
      return AppColors.buddhism;
    case 'công giáo':
      return AppColors.catholic;
    case 'cao đài':
      return AppColors.caodai;
    case 'hòa hảo':
      return AppColors.hoahao;
    case 'tin lành':
      return AppColors.protestant;
    case 'hồi giáo':
      return AppColors.islam;
    default:
      return AppColors.folk;
  }
}
