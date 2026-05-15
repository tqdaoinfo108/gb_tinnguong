import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../widgets/secure_network_image.dart';
import '../../../../data/models/event_album_model.dart';
import '../../controllers/map_controller.dart';

/// Grid album — tap mở lightbox ảnh.
class AlbumGrid extends GetView<GisMapController> {
  const AlbumGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final albums = controller.allAlbums;
      if (albums.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
            child: Row(
              children: [
                const Icon(Icons.photo_library_outlined,
                    size: 16, color: AppColors.inkSoft),
                const SizedBox(width: 6),
                Text(
                  'Album ảnh (${albums.length})',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              return _AlbumTile(album: albums[index]);
            },
          ),
        ],
      );
    });
  }
}

class _AlbumTile extends StatelessWidget {
  final EventAlbumModel album;
  const _AlbumTile({required this.album});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GisMapController>();
    return GestureDetector(
      onTap: () => controller.onAlbumTap(album),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (album.imagePath != null && album.imagePath!.isNotEmpty)
              SecureNetworkImage(
                imagePath: album.imagePath!,
                fit: BoxFit.cover,
              )
            else
              Container(
                color: AppColors.parchment,
                child: const Icon(Icons.photo_album_outlined,
                    color: AppColors.inkFaint),
              ),
            // Label overlay
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.65),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  album.albumName ?? 'Album',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
