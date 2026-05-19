import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/network/dio_client.dart';
import '../../../routes/app_routes.dart';

// ── Brand tokens (dark editorial) ────────────────────────────────────────────
const _bg       = Color(0xFF0C1420);   // deep navy
const _line     = Color(0xFF1E2D3D);   // hairline
const _white    = Color(0xFFF5F2EC);   // warm white
const _muted    = Color(0xFF8A97A8);   // muted label
const _gold     = Color(0xFFC9A84C);   // gold accent
const _primary  = Color(0xFF3B6FA0);   // blue primary

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // Controllers
  late final AnimationController _lineCtrl;   // top gold line width
  late final AnimationController _logoCtrl;   // logo + card
  late final AnimationController _textCtrl;   // title + sub
  late final AnimationController _barCtrl;    // progress bar at bottom
  late final AnimationController _countCtrl;  // cycling status dots

  // Animations
  late final Animation<double> _lineW;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _textFade;
  late final Animation<Offset>  _textSlide;
  late final Animation<double> _barProgress;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:            Colors.transparent,
      statusBarIconBrightness:   Brightness.light,
      systemNavigationBarColor:  _bg,
    ));

    _lineCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 550));
    _lineW = Tween<double>(begin: 0, end: 48).animate(
        CurvedAnimation(parent: _lineCtrl, curve: Curves.easeOutCubic));

    _logoCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 600));
    _logoFade  = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut);
    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutBack));

    _textCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 480));
    _textFade  = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic));

    _barCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 2000));
    _barProgress = CurvedAnimation(parent: _barCtrl, curve: Curves.easeInOut);

    _countCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 900))
      ..repeat();

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 80));
    _lineCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 260));
    _logoCtrl.forward();
    _barCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 320));
    _textCtrl.forward();

    // Auth check while animating
    final token = await DioClient().getToken();
    final next  = token != null ? AppRoutes.main : AppRoutes.login;

    // Hold until bar finishes (2 000 ms from when it started)
    await Future.delayed(const Duration(milliseconds: 1800));

    if (mounted) Get.offAllNamed(next);
  }

  @override
  void dispose() {
    _lineCtrl.dispose();
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _barCtrl.dispose();
    _countCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size   = MediaQuery.of(context).size;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [

          // ── Noise / grain texture ──────────────────────────────
          CustomPaint(
            size: size,
            painter: _NoisePainter(),
          ),

          // ── Decorative grid lines ──────────────────────────────
          CustomPaint(
            size: size,
            painter: _GridPainter(),
          ),

          // ── Main content ───────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Gold accent line
                AnimatedBuilder(
                  animation: _lineW,
                  builder: (ctx, x) => Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        width: _lineW.value,
                        height: 2,
                        decoration: BoxDecoration(
                          color: _gold,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Logo card
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoFade,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: _gold.withValues(alpha: 0.18),
                            blurRadius: 32,
                            spreadRadius: 0,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.45),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Image.asset(
                        'assets/app-icon-mark-1024.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Title + sub
                FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                    position: _textSlide,
                    child: Column(
                      children: [
                        // App name
                        Text(
                          'TÍN NGƯỠNG',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: _white,
                            letterSpacing: 2.5,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Thin divider
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20, height: 1,
                              color: _gold.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'GIS',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: _gold,
                                letterSpacing: 4,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 20, height: 1,
                              color: _gold.withValues(alpha: 0.5),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Tagline
                        Text(
                          'Hệ thống thông tin địa lý tín ngưỡng',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: _muted,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom bar ─────────────────────────────────────────
          Positioned(
            left: 0, right: 0,
            bottom: bottom + 0,
            child: FadeTransition(
              opacity: _textFade,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Meta row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'v1.0.0',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: _muted.withValues(alpha: 0.6),
                            letterSpacing: 1.2,
                          ),
                        ),
                        _BlinkingDots(ctrl: _countCtrl),
                        Text(
                          '© 2025',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: _muted.withValues(alpha: 0.6),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress bar
                  AnimatedBuilder(
                    animation: _barProgress,
                    builder: (ctx, x) => Stack(
                      children: [
                        // Track
                        Container(
                          height: 2,
                          color: _line,
                        ),
                        // Fill
                        FractionallySizedBox(
                          widthFactor: _barProgress.value,
                          child: Container(
                            height: 2,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_primary, _gold],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Corner accent — top right ──────────────────────────
          Positioned(
            top: 0, right: 0,
            child: FadeTransition(
              opacity: _logoFade,
              child: CustomPaint(
                size: const Size(60, 60),
                painter: _CornerPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Blinking status dots ──────────────────────────────────────────────────────

class _BlinkingDots extends StatelessWidget {
  final AnimationController ctrl;
  const _BlinkingDots({required this.ctrl});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ctrl,
    builder: (ctx, child) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final phase  = (ctrl.value + i * 0.25) % 1.0;
          final bright = math.sin(phase * math.pi).clamp(0.0, 1.0);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Container(
              width: 4, height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _gold.withValues(alpha: 0.25 + bright * 0.75),
              ),
            ),
          );
        }),
      );
    },
  );
}

// ── Corner bracket painter ────────────────────────────────────────────────────

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color  = _gold.withValues(alpha: 0.35)
      ..strokeWidth = 1.5
      ..style  = PaintingStyle.stroke;

    const len = 18.0;
    // Top-right corner bracket
    canvas.drawLine(
        const Offset(0, 0) + Offset(size.width - len, 0),
        Offset(size.width, 0), paint);
    canvas.drawLine(
        Offset(size.width, 0),
        Offset(size.width, len), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}

// ── Subtle noise painter ──────────────────────────────────────────────────────

class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng   = math.Random(42);
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 1800; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final a = rng.nextDouble() * 0.045;
      paint.color = Colors.white.withValues(alpha: a);
      canvas.drawCircle(Offset(x, y), 0.6, paint);
    }
  }

  @override
  bool shouldRepaint(_NoisePainter old) => false;
}

// ── Editorial grid lines ──────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = const Color(0xFF1E2D3D).withValues(alpha: 0.6)
      ..strokeWidth = 0.5;

    // 3 vertical lines
    for (final x in [size.width * 0.25, size.width * 0.5, size.width * 0.75]) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height * 0.18), paint);
      canvas.drawLine(
          Offset(x, size.height * 0.82), Offset(x, size.height), paint);
    }

    // 2 horizontal lines (top / bottom zones)
    canvas.drawLine(
        Offset(0, size.height * 0.15),
        Offset(size.width, size.height * 0.15), paint);
    canvas.drawLine(
        Offset(0, size.height * 0.85),
        Offset(size.width, size.height * 0.85), paint);
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}
