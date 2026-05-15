import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/secure_network_image.dart';
import '../../controllers/map_controller.dart';

/// Carousel ảnh bìa — horizontal scroll, nhiều ảnh visible cùng lúc (theo design).
class BannerCarousel extends GetView<GisMapController> {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final images = controller.bannerImages;
      if (images.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 140,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: images.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final banner = images[index];
            // Ảnh đầu rộng hơn, ảnh sau thu nhỏ dần (theo design)
            final width = index == 0
                ? 220.0
                : index == 1
                    ? 160.0
                    : 120.0;
            return ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: width,
                height: 140,
                child: SecureNetworkImage(
                  imagePath: banner.imagePath ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
