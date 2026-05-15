import 'package:flutter/material.dart';

enum ImgVariant { light, dark, warm, sage, clay }

class ImgPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final String tag;
  final ImgVariant variant;
  final BorderRadius? borderRadius;

  const ImgPlaceholder({
    super.key,
    this.width,
    this.height,
    this.tag = '',
    this.variant = ImgVariant.light,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final (c1, c2, textColor) = switch (variant) {
      ImgVariant.dark  => (const Color(0xFF2A394A), const Color(0xFF243345), const Color(0x73FFFFFF)),
      ImgVariant.warm  => (const Color(0xFFD4C9A8), const Color(0xFFC4B896), const Color(0xFF1E2D3D)),
      ImgVariant.sage  => (const Color(0xFFC4CDB8), const Color(0xFFB4BDA8), const Color(0xFF1E2D3D)),
      ImgVariant.clay  => (const Color(0xFFD8B8A0), const Color(0xFFC8A890), const Color(0xFF1E2D3D)),
      ImgVariant.light => (const Color(0xFFE8E2D0), const Color(0xFFDDD5BF), const Color(0x801E2D3D)),
    };

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: _StripePainter(c1, c2),
          child: tag.isEmpty
              ? null
              : Center(
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 10,
                      color: textColor,
                      letterSpacing: 0.02,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  final Color c1;
  final Color c2;
  const _StripePainter(this.c1, this.c2);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = c1;
    final paint2 = Paint()..color = c2;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint1);

    const step = 16.0;
    final p = Path();
    for (double x = -size.height; x < size.width + size.height; x += step * 2) {
      p.moveTo(x, 0);
      p.lineTo(x + step, 0);
      p.lineTo(x + step + size.height, size.height);
      p.lineTo(x + size.height, size.height);
      p.close();
    }
    canvas.drawPath(p, paint2);
  }

  @override
  bool shouldRepaint(_StripePainter old) => old.c1 != c1 || old.c2 != c2;
}
