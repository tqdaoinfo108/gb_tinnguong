import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../../../widgets/circle_icon_button.dart';
import '../../../widgets/status_pill.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: top + 56)),
              SliverToBoxAdapter(child: _FeaturedBanner()),
              SliverToBoxAdapter(child: _AlbumMeta()),
              SliverToBoxAdapter(child: _PhotoGrid()),
              SliverToBoxAdapter(child: _OtherAlbums()),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
          _StickyNav(top: top, context: context),
        ],
      ),
    );
  }
}

// ─── Sticky Frosted Nav ────────────────────────────────────────

class _StickyNav extends StatelessWidget {
  final double top;
  final BuildContext context;
  const _StickyNav({required this.top, required this.context});

  @override
  Widget build(BuildContext _) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: AppColors.parchment.withValues(alpha: 0.92),
            padding: EdgeInsets.fromLTRB(16, top + 8, 16, 8),
            child: Row(
              children: [
                CircleIconButton(
                  icon: Icons.chevron_left_rounded,
                  size: 38,
                  iconSize: 20,
                  onTap: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Lễ Phật Đản 2025', style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink,
                      )),
                      Text('48 ảnh · 18/05/2025', style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.inkSoft,
                      )),
                    ],
                  ),
                ),
                const CircleIconButton(
                  icon: Icons.file_download_outlined,
                  size: 38,
                  iconSize: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ─── Featured Banner ───────────────────────────────────────────

class _FeaturedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 220,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _ImgPlaceholder(variant: _ImgVariant.warm),
              // gradient overlay bottom
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xCC1E2D3D), Colors.transparent],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 14, left: 14,
                child: Row(children: [
                  const Icon(Icons.photo_library_outlined, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text('48 ảnh', style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white,
                  )),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Album Meta ────────────────────────────────────────────────

class _AlbumMeta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lễ Phật Đản 2025', style: GoogleFonts.inter(
                  fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink,
                  letterSpacing: -0.01,
                )),
                const SizedBox(height: 4),
                Row(children: [
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(color: AppColors.buddhism, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 5),
                  Text('Chùa Pháp Hoa · Phường 5', style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.inkSoft,
                  )),
                ]),
              ],
            ),
          ),
          const StatusPill(kind: PillKind.emerald, label: 'Đang diễn ra'),
        ],
      ),
    );
  }
}

// ─── Photo Grid ────────────────────────────────────────────────

class _PhotoGrid extends StatelessWidget {
  static const _variants = [
    _ImgVariant.warm, _ImgVariant.sage, _ImgVariant.clay, _ImgVariant.neutral,
    _ImgVariant.warm, _ImgVariant.clay, _ImgVariant.sage, _ImgVariant.neutral,
    _ImgVariant.warm, _ImgVariant.clay, _ImgVariant.sage, _ImgVariant.warm,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tất cả · 48 ảnh', style: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w600,
            color: AppColors.inkFaint, letterSpacing: 0.04,
          )),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: _variants.length,
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _ImgPlaceholder(variant: _variants[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Other Albums ──────────────────────────────────────────────

class _OtherAlbums extends StatelessWidget {
  static const _otherData = [
    (_ImgVariant.sage, 'Vu Lan 2024', '32 ảnh'),
    (_ImgVariant.clay, 'Tết Nguyên Đán 2025', '56 ảnh'),
    (_ImgVariant.neutral, 'Khóa tu mùa hè', '24 ảnh'),
    (_ImgVariant.warm, 'Đại lễ Phật giáo', '18 ảnh'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text('Album khác của cơ sở', style: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink,
          )),
        ),
        SizedBox(
          height: 148,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _otherData.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final (variant, title, count) = _otherData[i];
              return _AlbumCardSmall(variant: variant, title: title, count: count);
            },
          ),
        ),
      ],
    );
  }
}

class _AlbumCardSmall extends StatelessWidget {
  final _ImgVariant variant;
  final String title;
  final String count;
  const _AlbumCardSmall({required this.variant, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 140, height: 105,
              child: _ImgPlaceholder(variant: variant),
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink,
          ), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(count, style: GoogleFonts.inter(
            fontSize: 11, color: AppColors.inkSoft,
          )),
        ],
      ),
    );
  }
}

// ─── Image Placeholder ─────────────────────────────────────────

enum _ImgVariant { warm, sage, clay, neutral }

class _ImgPlaceholder extends StatelessWidget {
  final _ImgVariant variant;
  const _ImgPlaceholder({required this.variant});

  static const _gradients = {
    _ImgVariant.warm: [Color(0xFFD4A96A), Color(0xFFB8855A)],
    _ImgVariant.sage: [Color(0xFF8AAE8A), Color(0xFF6A8E6A)],
    _ImgVariant.clay: [Color(0xFFB87B6A), Color(0xFF9A6555)],
    _ImgVariant.neutral: [Color(0xFF8A9AAA), Color(0xFF6A7A8A)],
  };

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[variant]!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.white38, size: 28),
      ),
    );
  }
}
