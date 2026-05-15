import 'package:flutter/material.dart';
import '../../core/values/app_colors.dart';
import '../../core/values/app_text_styles.dart';

/// Section header dùng chung: Tiêu đề bên trái + nút action bên phải.
/// Ví dụ: "Hiệu suất tuần này" [Chi tiết >]
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h4),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
