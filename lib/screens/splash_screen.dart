import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  Widget _buildColoredLogo() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, fontFamily: 'Nunito', letterSpacing: -2),
        children: [
          TextSpan(text: 'D', style: TextStyle(color: Color(0xFF1E3A8A))), // Dark Blue
          TextSpan(text: 'y', style: TextStyle(color: Color(0xFFE53935))), // Red
          TextSpan(text: 'R', style: TextStyle(color: Color(0xFF1E3A8A))), // Dark Blue
          TextSpan(text: 'a', style: TextStyle(color: Color(0xFFFBC02D))), // Yellow
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),
              _buildColoredLogo(),
              // Placeholder for the large mascot image
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.face_retouching_natural, size: 150, color: Color(0xFFE53935)),
                        SizedBox(height: 10),
                        Text('(Mascot Placeholder)', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: const [
                  Text(
                    'Financial Literacy\nfor Young Minds',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E3A8A),
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 8, color: Color(0xFF00B4D8)),
                      SizedBox(width: 8),
                      Text(
                        'Wise Today. Wealthy Tomorrow.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE53935),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.circle, size: 8, color: Color(0xFF00B4D8)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
