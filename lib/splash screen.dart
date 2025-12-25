import 'package:flutter/material.dart';
import 'on boarding screen.dart';

/// =======================================================
/// 🔹 SPLASH SCREEN (PROFESSIONAL)
// =======================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6F4E37),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔹 LOGO IMAGE
                Image.asset(
                  "assets/images/coffee.png",
                  height: 120,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 8),

                /// 🔹 APP NAME
                const Text(
                  "Coffee Taste",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3,
                  ),
                ),

                const SizedBox(height: 6),

                /// 🔹 TAGLINE
                const Text(
                  "Find your perfect brew",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

