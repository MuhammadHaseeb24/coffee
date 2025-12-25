
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login screen.dart';
import 'main.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown.shade100,
              ),
              child: Padding(
                padding: const EdgeInsets.all(30), // image breathing space
                child: Image.asset(
                  "assets/images/coffee.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),


            const SizedBox(height: 40),

            /// Title
            const Text(
              "Find your favorite\nCoffee Taste!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 14),

            /// Subtitle
            const Text(
              "We provide the best coffee\nfor you from all over the world.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 40),

            /// Get Started Button
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: Container(
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF6F4E37),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}