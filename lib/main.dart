import 'package:coffee/splash%20screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoffeeApp());
}

/// =======================================================
/// 🔹 ROOT APP
/// =======================================================
class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Taste',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF8F5F2),
        primaryColor: const Color(0xFF6F4E37),
      ),
      home: const SplashScreen(),
    );
  }
}


