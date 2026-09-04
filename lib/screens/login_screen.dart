import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  final TextEditingController _admissionController = TextEditingController();
  final TextEditingController _mpinController = TextEditingController();

  @override
  void dispose() {
    _admissionController.dispose();
    _mpinController.dispose();
    super.dispose();
  }

  // =============================================================================
  // BUBBLY MULTI-COLOR DYRA LOGO WITH WHISKERS & SLOGAN BANNER
  // =============================================================================
  Widget _buildBubblyLogo() {
    return Column(
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
                    color: Color(0xFF10355E), // Deep Navy Blue
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
                color: Color(0xFF06B6D4), // Cyan Teal
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
                color: Color(0xFFDA251D), // Bold Red
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
                    color: Color(0xFFF59E0B), // Warm Yellow/Orange
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
          painter: LoginSwooshArcPainter(),
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
              // 1. TOP BUBBLY LOGO
              // ===============================================================
              _buildBubblyLogo(),

              const SizedBox(height: 28),

              // ===============================================================
              // 2. GREETING & WAVING AVATAR HERO ROW
              // ===============================================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black, height: 1.15),
                            children: [
                              TextSpan(text: 'Welcome\nBack! '),
                              TextSpan(text: '🖐️', style: TextStyle(fontSize: 26)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Continue your journey\ntowards financial freedom.',
                          style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Mascot Image (Waving Avatar)
                  Container(
                    width: 120,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/images/mascot.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ===============================================================
              // 3. INPUT CARD CONTAINER (OUTLINED ROUNDED BOX)
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
                    // Admission Number Input Field
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

                    const SizedBox(height: 16),

                    // MPIN Input Field
                    TextField(
                      controller: _mpinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter your Mpin',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFEF3C7), // Soft Orange Circle
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.lock, color: Color(0xFFF59E0B), size: 18),
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

              const SizedBox(height: 16),

              // ===============================================================
              // 4. REMEMBER ME & FORGOT MPIN ROW
              // ===============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Remember Me Checkbox
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: const Color(0xFF06B6D4),
                          onChanged: (val) {
                            setState(() => _rememberMe = val ?? false);
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Remember me',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),

                  // Forgot MPIN
                  GestureDetector(
                    onTap: () {
                      _showForgotMpinDialog(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'Forgot Mpin?',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF06B6D4), // Cyan Teal
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '•••',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7C3AED), // Purple Dots
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ===============================================================
              // 5. CYAN LOGIN BUTTON WITH ARROW
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
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Positioned(
                        right: 8,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===============================================================
              // 6. OR DIVIDER ROW
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
              // 7. SCAN SCHOOL QR CODE BUTTON
              // ===============================================================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () {
                    _showQrScannerDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code_scanner, color: Color(0xFF2563EB), size: 22),
                      SizedBox(width: 10),
                      Text(
                        'Scan School QR Code',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Activate Account Link for New Students
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/activation');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("First time here? ", style: TextStyle(fontSize: 13, color: Colors.black54)),
                    Text(
                      "Activate Your Account",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF06B6D4)),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF06B6D4)),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===============================================================
              // 8. FOOTER HELP ROW
              // ===============================================================
              GestureDetector(
                onTap: () {
                  _showHelpDialog(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.headset_mic, size: 18, color: Color(0xFF7C3AED)),
                    SizedBox(width: 8),
                    Text(
                      'Need help? Contact your school administrator',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
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
  // INTERACTIVE DIALOGS (FORGOT MPIN, QR SCANNER, HELP)
  // =============================================================================
  void _showForgotMpinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lock_reset, color: Color(0xFF06B6D4)),
            SizedBox(width: 10),
            Text('Reset MPIN', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Please enter your registered Admission Number or contact your School Administrator to reset your 4-digit MPIN.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showQrScannerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.qr_code_scanner, color: Color(0xFF2563EB)),
            SizedBox(width: 10),
            Text('Scan QR Code', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2563EB), width: 2),
              ),
              child: const Icon(Icons.qr_code_2, size: 100, color: Color(0xFF2563EB)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Align school QR code inside frame to log in automatically.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            child: const Text('Simulate Scan & Login', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.headset_mic, color: Color(0xFF7C3AED)),
            SizedBox(width: 10),
            Text('Administrator Help', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'For login issues, admission number verification, or MPIN reset requests, please visit your school computer lab administrator or email support@dyra.edu.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SLOGAN SWOOSH ARC PAINTER FOR LOGIN SCREEN
// =============================================================================
class LoginSwooshArcPainter extends CustomPainter {
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

