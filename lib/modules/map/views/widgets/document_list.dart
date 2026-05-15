import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/app_colors.dart';
import '../../controllers/map_controller.dart';

/// Danh sách file tài liệu (PDF/DOCX/XLSX) — typeBannerID=2.
class DocumentList extends GetView<GisMapController> {
  const DocumentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final docs = controller.documents;
      if (docs.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
            child: Row(
              children: [
                const Icon(Icons.description_outlined,
                    size: 16, color: AppColors.inkSoft),
                const SizedBox(width: 6),
                Text(
                  'Văn bản (${docs.length})',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          ...docs.map((doc) => _DocumentRow(
                name: doc.bannerName ?? doc.imagePath ?? 'Tài liệu',
                extension: doc.fileExtension,
              )),
        ],
      );
    });
  }
}

class _DocumentRow extends StatelessWidget {
  final String name;
  final String extension;
  const _DocumentRow({required this.name, required this.extension});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _extColor(extension).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                extension.isNotEmpty ? extension : 'FILE',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: _extColor(extension),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.download_outlined,
              size: 18, color: AppColors.inkFaint),
        ],
      ),
    );
  }

  Color _extColor(String ext) {
    return switch (ext.toUpperCase()) {
      'PDF' => const Color(0xFFE74C3C),
      'DOC' || 'DOCX' => const Color(0xFF2F80ED),
      'XLS' || 'XLSX' => const Color(0xFF27AE60),
      _ => AppColors.inkSoft,
    };
  }
}
