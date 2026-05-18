import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/network/dio_client.dart';
import 'img_placeholder.dart';

/// Loads a remote image by [imagePath] (relative or absolute URL).
/// Falls back to [ImgPlaceholder] while loading or on error.
class NetworkImg extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final ImgVariant fallbackVariant;
  final String fallbackTag;

  const NetworkImg({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackVariant = ImgVariant.warm,
    this.fallbackTag = '',
  });

  String? get _url {
    final p = imagePath?.trim();
    if (p == null || p.isEmpty) return null;
    if (p.startsWith('http://') || p.startsWith('https://')) return p;
    // relative path — prepend base URL
    return '${DioClient.baseUrl}${p.startsWith('/') ? '' : '/'}$p';
  }

  @override
  Widget build(BuildContext context) {
    final url = _url;

    final placeholder = ImgPlaceholder(
      width: width,
      height: height,
      tag: fallbackTag,
      variant: fallbackVariant,
      borderRadius: borderRadius,
    );

    if (url == null) return placeholder;

    Widget img = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => placeholder,
      errorWidget: (_, __, ___) => placeholder,
    );

    if (borderRadius != null) {
      img = ClipRRect(borderRadius: borderRadius!, child: img);
    }

    return img;
  }
}
