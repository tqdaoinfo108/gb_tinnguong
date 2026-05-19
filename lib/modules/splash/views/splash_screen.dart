import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/values/app_colors.dart';
import '../../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late final AnimationController _fadeCtrl;
  late final AnimationController _dotCtrl;

  late final Animation<double> _topFade;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleFade;
  late final Animation<Offset>  _titleSlide;
  late final Animation<double> _subFade;
  late final Animation<double> _bottomFade;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:            Colors.transparent,
      statusBarIconBrightness:   Brightness.dark,
      systemNavigationBarColor:  AppColors.parchment,
    ));

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Top metadata: 0–25%
    _topFade = CurvedAnimation(
      parent: _fadeCtrl,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    );

    // Logo: 10–50%
    _logoFade  = CurvedAnimation(
      parent: _fadeCtrl,
      curve: const Interval(0.10, 0.50, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeCtrl,
        curve: const Interval(0.10, 0.55, curve: Curves.easeOutBack),
      ),
    );

    // Title: 35–70%
    _titleFade = CurvedAnimation(
      parent: _fadeCtrl,
      curve: const Interval(0.35, 0.70, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.18), end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeCtrl,
      curve: const Interval(0.35, 0.70, curve: Curves.easeOutCubic),
    ));

    // Subtitle: 50–80%
    _subFade = CurvedAnimation(
      parent: _fadeCtrl,
      curve: const Interval(0.50, 0.80, curve: Curves.easeOut),
    );

    // Bottom: 65–100%
    _bottomFade = CurvedAnimation(
      parent: _fadeCtrl,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    // Dot pulsing
    _dotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 120));
    _fadeCtrl.forward();

    final token = await DioClient().getToken();
    final next  = token != null ? AppRoutes.main : AppRoutes.login;

    // Wait for animation + minimum hold
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) Get.offAllNamed(next);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _dotCtrl.dispose();
    super.dispose();
  }

  String get _dateLabel {
    final now = DateTime.now();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$m · $d';
  }

  @override
  Widget build(BuildContext context) {
    final size   = MediaQuery.of(context).size;
    final top    = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: Stack(
        children: [

          // ── Radial vignette ─────────────────────────────────
          CustomPaint(size: size, painter: _VignettePainter()),

          // ── Top metadata ────────────────────────────────────
          Positioned(
            top: top + 14, left: 20, right: 20,
            child: FadeTransition(
              opacity: _topFade,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TIN-NGUONG / V1.0.0',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.inkFaint,
                      letterSpacing: 1.4,
                    ),
                  ),
                  Text(
                    _dateLabel,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.inkFaint,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Center: logo + title + subtitle ─────────────────
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Logo
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Image.asset(
                        'assets/app-icon-mark-1024.png',
                        width: 160,
                        height: 160,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  FadeTransition(
                    opacity: _titleFade,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Text(
                        'Tín Ngưỡng',
                        style: GoogleFonts.inter(
                          fontSize: 46,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          letterSpacing: -1.0,
                          height: 1.05,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  FadeTransition(
                    opacity: _subFade,
                    child: Column(
                      children: [
                        Text(
                          'Cơ sở tôn giáo · lễ hội · tín đồ',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.inkSoft,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Phường 5 · Bình Thạnh',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.inkSoft,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom: dots + label ─────────────────────────────
          Positioned(
            left: 0, right: 0,
            bottom: bottom + 20,
            child: FadeTransition(
              opacity: _bottomFade,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pagination dots
                  _PaginationDots(ctrl: _dotCtrl),

                  const SizedBox(height: 14),

                  Text(
                    'UBND PHƯỜNG 5',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkFaint,
                      letterSpacing: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pagination dots ───────────────────────────────────────────────────────────

class _PaginationDots extends StatelessWidget {
  final AnimationController ctrl;
  const _PaginationDots({required this.ctrl});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ctrl,
    builder: (ctx, child) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final isActive = i == 1; // middle dot active
          final phase  = (ctrl.value + i * 0.3) % 1.0;
          final bright = math.sin(phase * math.pi).clamp(0.0, 1.0);
          final alpha  = isActive ? 0.4 + bright * 0.6 : 0.25;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.5),
            child: Container(
              width: isActive ? 7 : 6,
              height: isActive ? 7 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.primary.withValues(alpha: alpha)
                    : AppColors.inkFaint.withValues(alpha: 0.3),
              ),
            ),
          );
        }),
      );
    },
  );
}

// ── Radial vignette ───────────────────────────────────────────────────────────

class _VignettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.42);
    final radius = size.width * 1.1;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.0),
          AppColors.ink.withValues(alpha: 0.05),
        ],
        stops: const [0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_VignettePainter old) => false;
}
