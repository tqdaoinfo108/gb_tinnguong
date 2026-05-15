import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../widgets/secure_network_image.dart';
import '../../controllers/map_controller.dart';

/// Fullscreen ảnh viewer — hiển thị ảnh từ album.
class ImageLightbox extends GetView<GisMapController> {
  const ImageLightbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final album = controller.selectedAlbum.value;
      if (album == null) return const SizedBox.shrink();

      final images = controller.albumImages;

      return Material(
        color: Colors.black.withValues(alpha: 0.92),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        album.albumName ?? 'Album',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: controller.closeAlbumViewer,
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: controller.isAlbumLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white70))
                    : images.isEmpty
                        ? Center(
                            child: Text(
                              'Không có ảnh',
                              style: GoogleFonts.inter(
                                  color: Colors.white54, fontSize: 14),
                            ),
                          )
                        : PageView.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SecureNetworkImage(
                                          imagePath:
                                              images[index].imagePath ?? '',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '${index + 1} / ${images.length}',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    if (images[index].description != null &&
                                        images[index].description!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          images[index].description!,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
