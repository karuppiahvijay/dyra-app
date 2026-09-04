import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  void _navigateToLogin() {
    _timer?.cancel();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 5), () {
      _navigateToLogin();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: _navigateToLogin,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 10),

                  // =============================================================
                  // 1. TOP LOGO SECTION: "DyRa" WITH SWOOSHES & SPARKLES
                  // =============================================================
                  const DyRaLogoHeader(),

                  const SizedBox(height: 24),

                  // =============================================================
                  // 2. CENTER AVATAR SECTION WITH GRADIENT CIRCLE RING & SPARKLE
                  // =============================================================
                  SizedBox(
                    width: min(screenWidth * 0.78, 310),
                    height: min(screenWidth * 0.78, 310),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Gradient Ring Arc (Teal -> Orange)
                        CustomPaint(
                          size: Size(min(screenWidth * 0.78, 310), min(screenWidth * 0.78, 310)),
                          painter: AvatarRingPainter(),
                        ),

                        // Mascot Image Container
                        Container(
                          width: min(screenWidth * 0.68, 270),
                          height: min(screenWidth * 0.68, 270),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/mascot.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Top Right Diamond Sparkle Star (Orange)
                        const Positioned(
                          top: 24,
                          right: 28,
                          child: SparkleStar(color: Color(0xFFE97425), size: 24),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // =============================================================
                  // 3. SUBTITLE SECTION: "Financial Literacy / for Young Minds"
                  // =============================================================
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AccentDashes(color: Color(0xFF06B6D4), isLeft: true),
                          const SizedBox(width: 8),
                          const Text(
                            'Financial Literacy',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF10355E),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const AccentDashes(color: Color(0xFFE97425), isLeft: false),
                        ],
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'for Young Minds',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF10355E),
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Horizontal Divider with Diamond Sparkle
                      SizedBox(
                        width: 220,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.5,
                                color: const Color(0xFF0F4C5C).withOpacity(0.6),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                              child: SparkleStar(color: Color(0xFFE97425), size: 16),
                            ),
                            Expanded(
                              child: Container(
                                height: 1.5,
                                color: const Color(0xFFE97425).withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  // =============================================================
                  // 4. BOTTOM CURVED BANNER TAGLINE ("Wise Today. Wealthy Tomorrow.")
                  // =============================================================
                  CustomPaint(
                    painter: CurvedArcBannerPainter(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Teal Dot
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0F4C5C),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Text
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: 'Wise Today. ',
                                  style: TextStyle(color: Color(0xFF0D3B54)),
                                ),
                                TextSpan(
                                  text: 'Wealthy Tomorrow.',
                                  style: TextStyle(color: Color(0xFFDA251D)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Red Dot
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDA251D),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// DYRA LOGO HEADER WIDGET (MATCHING TOP LOGO IN SCREENSHOT)
// =============================================================================
class DyRaLogoHeader extends StatelessWidget {
  const DyRaLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logo Text
          Positioned(
            top: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                // "Dy" Script
                Text(
                  'Dy',
                  style: TextStyle(
                    fontSize: 68,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Georgia',
                    color: const Color(0xFF0D3B54), // Dark Teal
                    height: 1.0,
                  ),
                ),
                // "R" Bold Red
                const Text(
                  'R',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFDA251D), // Bold Red
                    height: 1.0,
                  ),
                ),
                // "a" Orange Script
                const Text(
                  'a',
                  style: TextStyle(
                    fontSize: 62,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFE97425), // Warm Orange
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),

          // Swooshes Underline
          Positioned(
            bottom: 6,
            child: CustomPaint(
              size: const Size(240, 24),
              painter: LogoSwooshPainter(),
            ),
          ),

          // Sparkle Stars Top Right of 'a'
          const Positioned(
            right: 28,
            top: 8,
            child: SparkleStar(color: Color(0xFF0F4C5C), size: 14),
          ),
          const Positioned(
            right: 14,
            top: 18,
            child: SparkleStar(color: Color(0xFFDA251D), size: 12),
          ),

          // Sparkle Star Under 'Dy' Swoosh
          const Positioned(
            left: 100,
            bottom: 2,
            child: SparkleStar(color: Color(0xFFE97425), size: 12),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SPARKLE STAR (4-POINT DIAMOND STAR)
// =============================================================================
class SparkleStar extends StatelessWidget {
  final Color color;
  final double size;

  const SparkleStar({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: PointStarPainter(color: color),
    );
  }
}

class PointStarPainter extends CustomPainter {
  final Color color;
  PointStarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double rx = size.width / 2;
    final double ry = size.height / 2;

    path.moveTo(cx, cy - ry);
    path.quadraticBezierTo(cx, cy, cx + rx, cy);
    path.quadraticBezierTo(cx, cy, cx, cy + ry);
    path.quadraticBezierTo(cx, cy, cx - rx, cy);
    path.quadraticBezierTo(cx, cy, cx, cy - ry);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// =============================================================================
// LOGO SWOOSH PAINTER (TEAL SWOOSH LEFT + ORANGE SWOOSH RIGHT)
// =============================================================================
class LogoSwooshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint tealPaint = Paint()
      ..color = const Color(0xFF0F4C5C)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint orangePaint = Paint()
      ..color = const Color(0xFFE97425)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Teal Swoosh under "Dy"
    final Path tealPath = Path();
    tealPath.moveTo(10, size.height * 0.2);
    tealPath.quadraticBezierTo(
      size.width * 0.3, size.height * 1.1,
      size.width * 0.45, size.height * 0.4,
    );
    canvas.drawPath(tealPath, tealPaint);

    // Orange Swoosh under "Ra"
    final Path orangePath = Path();
    orangePath.moveTo(size.width * 0.45, size.height * 0.9);
    orangePath.quadraticBezierTo(
      size.width * 0.75, size.height * 1.2,
      size.width * 0.95, size.height * 0.2,
    );
    canvas.drawPath(orangePath, orangePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// =============================================================================
// AVATAR GRADIENT RING CIRCLE PAINTER
// =============================================================================
class AvatarRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(8, 8, size.width - 16, size.height - 16);
    
    // Teal Arc (Left)
    final Paint tealPaint = Paint()
      ..color = const Color(0xFF0F4C5C)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawArc(rect, pi * 0.6, pi * 0.9, false, tealPaint);

    // Orange Arc (Right)
    final Paint orangePaint = Paint()
      ..color = const Color(0xFFE97425)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawArc(rect, -pi * 0.35, pi * 0.9, false, orangePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// =============================================================================
// ACCENT DASHES WIDGET (3 DASHES ON LEFT & RIGHT OF TITLE)
// =============================================================================
class AccentDashes extends StatelessWidget {
  final Color color;
  final bool isLeft;

  const AccentDashes({super.key, required this.color, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          width: 14,
          height: 3,
          margin: const EdgeInsets.symmetric(vertical: 1.5),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        Container(
          width: 18,
          height: 3,
          margin: const EdgeInsets.symmetric(vertical: 1.5),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        Container(
          width: 10,
          height: 3,
          margin: const EdgeInsets.symmetric(vertical: 1.5),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
      ],
    );
  }
}

// =============================================================================
// CURVED ARC BANNER PAINTER FOR BOTTOM TEXT ("Wise Today. Wealthy Tomorrow.")
// =============================================================================
class CurvedArcBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF0D3B54).withOpacity(0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.moveTo(4, size.height * 0.85);
    path.quadraticBezierTo(
      size.width / 2, size.height + 8,
      size.width - 4, size.height * 0.85,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
