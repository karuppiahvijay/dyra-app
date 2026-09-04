import 'package:flutter/material.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final TextEditingController _admissionController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _admissionController.dispose();
    _dobController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  // =============================================================================
  // BUBBLY DYRA LOGO WITH FLOATING STARS & CRESCENT MOONS
  // =============================================================================
  Widget _buildBubblyLogoHeader() {
    return SizedBox(
      height: 120,
      width: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Floating Stars & Moons
          // Left Star (Orange)
          const Positioned(
            left: 12,
            top: 24,
            child: Icon(Icons.star, color: Color(0xFFF59E0B), size: 16),
          ),
          // Left Moon (Cyan/Blue)
          const Positioned(
            left: 0,
            bottom: 28,
            child: Icon(Icons.nightlight_round, color: Color(0xFF06B6D4), size: 18),
          ),
          // Right Star (Red/Orange)
          const Positioned(
            right: 10,
            top: 18,
            child: Icon(Icons.star, color: Color(0xFFDA251D), size: 16),
          ),
          // Right Moon (Purple)
          const Positioned(
            right: 0,
            bottom: 30,
            child: Icon(Icons.nightlight_round, color: Color(0xFF7C3AED), size: 18),
          ),

          // Main Logo Letters
          Positioned(
            top: 8,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // D with Orange Whiskers
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 3, height: 8, color: const Color(0xFFF97316)),
                            const SizedBox(width: 3),
                            Container(width: 3, height: 10, color: const Color(0xFFF97316)),
                            const SizedBox(width: 3),
                            Container(width: 3, height: 8, color: const Color(0xFFF97316)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'D',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF10355E),
                            fontFamily: 'Nunito',
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                    // y (Cyan/Teal)
                    const Text(
                      'y',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF06B6D4),
                        fontFamily: 'Nunito',
                        height: 1.0,
                      ),
                    ),
                    // R (Red)
                    const Text(
                      'R',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFDA251D),
                        fontFamily: 'Nunito',
                        height: 1.0,
                      ),
                    ),
                    // a with Teal Whiskers
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 3, height: 8, color: const Color(0xFF06B6D4)),
                            const SizedBox(width: 3),
                            Container(width: 3, height: 10, color: const Color(0xFF06B6D4)),
                            const SizedBox(width: 3),
                            Container(width: 3, height: 8, color: const Color(0xFF06B6D4)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'a',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFF59E0B),
                            fontFamily: 'Nunito',
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                // Slogan Banner with Curved Underline Arc
                CustomPaint(
                  painter: ActivationSwooshArcPainter(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Teal Dot
                        Container(
                          width: 5, height: 5,
                          decoration: const BoxDecoration(color: Color(0xFF06B6D4), shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: 'Wise Today. ', style: TextStyle(color: Color(0xFF10355E))),
                              TextSpan(text: 'Wealthy Tomorrow.', style: TextStyle(color: Color(0xFFDA251D))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Red Dot
                        Container(
                          width: 5, height: 5,
                          decoration: const BoxDecoration(color: Color(0xFFDA251D), shape: BoxShape.circle),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // ===============================================================
              // 1. TOP BUBBLY LOGO WITH STARS & MOONS
              // ===============================================================
              _buildBubblyLogoHeader(),

              const SizedBox(height: 24),

              // ===============================================================
              // 2. GREETING TITLE & SUBTITLE
              // ===============================================================
              const Text(
                'Activate Your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF10355E), // Navy Blue
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Its your first time here! Verify your details to create your secure MPIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ===============================================================
              // 3. INPUT CARD CONTAINER WITH 3 FIELDS & DOTS
              // ===============================================================
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Field 1: Admission Number
                    TextField(
                      controller: _admissionController,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Admission number',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3E8FF), // Soft Purple Circle
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person, color: Color(0xFF7C3AED), size: 20),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),
                    // Three Purple Dots
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child: Text(
                          '•••',
                          style: TextStyle(fontSize: 10, color: Color(0xFF7C3AED), letterSpacing: 2, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Field 2: Date of Birth
                    TextField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        hintText: 'Date of Birth (dd/mm/yy)',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0F2FE), // Soft Cyan Circle
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.badge_outlined, color: Color(0xFF0284C7), size: 20),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Field 3: School Activation Code
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        hintText: 'School Activation Code',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3E8FF), // Soft Purple Circle
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.school, color: Color(0xFF7C3AED), size: 20),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              // Three Purple Dots below input card
              const Text(
                '•••',
                style: TextStyle(fontSize: 12, color: Color(0xFF7C3AED), letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // ===============================================================
              // 4. CYAN VERIFY BUTTON WITH SHIELD ICON
              // ===============================================================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF06B6D4), // Cyan/Teal
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  onPressed: () {
                    _showMPINCreationModal(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.verified_user, color: Colors.white, size: 22),
                      SizedBox(width: 10),
                      Text(
                        'Verify',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===============================================================
              // 5. OR DIVIDER ROW
              // ===============================================================
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'OR',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              const SizedBox(height: 20),

              // ===============================================================
              // 6. BOTTOM CARD: "ALREADY ACTIVATED?" + BACK TO LOGIN
              // ===============================================================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE), // Soft Cyan/Blue Tint
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Already Activated?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.keyboard_double_arrow_left, size: 18, color: Color(0xFF0284C7)),
                              SizedBox(width: 4),
                              Text(
                                'Back to Login',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Right Illustration Badge
                    SizedBox(
                      width: 70,
                      height: 56,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // User Profile Icon Blue
                          const Positioned(
                            left: 10,
                            bottom: 4,
                            child: Icon(Icons.account_circle, size: 40, color: Color(0xFF0284C7)),
                          ),
                          // Lock Icon Cyan
                          const Positioned(
                            right: 4,
                            bottom: 0,
                            child: Icon(Icons.lock_open, size: 26, color: Color(0xFF06B6D4)),
                          ),
                          // Orange Coin Top Right
                          const Positioned(
                            right: 8,
                            top: 2,
                            child: Icon(Icons.circle, size: 14, color: Color(0xFFF59E0B)),
                          ),
                          // Yellow Star Top Left
                          const Positioned(
                            left: 2,
                            top: 6,
                            child: Icon(Icons.star, size: 14, color: Color(0xFFFBBF24)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================================
  // MPIN CREATION MODAL ON VERIFICATION SUCCESS
  // =============================================================================
  void _showMPINCreationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Icon(Icons.verified, color: Color(0xFF06B6D4), size: 48),
            const SizedBox(height: 12),
            const Text(
              'Account Verified!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF10355E)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a 4-digit MPIN for quick daily login to DyRa.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 12, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '••••',
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                child: const Text('Save MPIN & Enter DyRa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SLOGAN SWOOSH ARC PAINTER FOR ACTIVATION SCREEN
// =============================================================================
class ActivationSwooshArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF10355E).withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.moveTo(2, size.height * 0.9);
    path.quadraticBezierTo(
      size.width / 2, size.height + 6,
      size.width - 2, size.height * 0.9,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

