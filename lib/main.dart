import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/activation_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const DyRaApp());
}

class DyRaApp extends StatelessWidget {
  const DyRaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DyRa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8)),
        fontFamily: 'Nunito',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/activation': (context) => const ActivationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
