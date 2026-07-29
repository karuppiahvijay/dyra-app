import 'package:flutter/material.dart';

class ActivationScreen extends StatelessWidget {
  const ActivationScreen({super.key});

  Widget _buildColoredLogo() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Nunito', letterSpacing: -1),
        children: [
          TextSpan(text: 'D', style: TextStyle(color: Color(0xFF1E3A8A))), 
          TextSpan(text: 'y', style: TextStyle(color: Color(0xFFE53935))), 
          TextSpan(text: 'R', style: TextStyle(color: Color(0xFF1E3A8A))), 
          TextSpan(text: 'a', style: TextStyle(color: Color(0xFFFBC02D))), 
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildColoredLogo(),
              const SizedBox(height: 4),
              const Text(
                '• Wise Today. Wealthy Tomorrow. •',
                style: TextStyle(fontSize: 10, color: Color(0xFFE53935), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              const Text(
                'Activate Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Its your first time here! Verify your details to\ncreate your secure MPIN',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF6C5CE7)),
                  hintText: 'Enter Your Admission number',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_month, color: Color(0xFF00B4D8)),
                  hintText: 'Date of Birth (dd/mm/yy)',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.badge, color: Color(0xFF6C5CE7)),
                  hintText: 'School Activation Code',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B4D8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.verified_user_outlined),
                  label: const Text('Verify', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('OR', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F8FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Already Activated?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: Row(
                            children: const [
                              Icon(Icons.arrow_back_ios, size: 14, color: Color(0xFF00B4D8)),
                              Text('Back to Login', style: TextStyle(color: Color(0xFF00B4D8), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.admin_panel_settings, size: 40, color: Color(0xFF00B4D8)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
