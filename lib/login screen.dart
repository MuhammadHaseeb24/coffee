import 'package:flutter/material.dart';
import 'home screen.dart';
import 'sign up screen.dart';

/// =======================================================
/// 🔹 LOGIN SCREEN (EXACT IMAGE STYLE)
// =======================================================
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                /// 🔹 TOP IMAGE
                Image.asset(
                  "assets/images/coffee.png",
                  height: 150,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 24),

                /// 🔹 TITLE
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "We've already met!",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 28),

                /// 🔹 PHONE LABEL
                _label("PHONE NUMBER"),
                const SizedBox(height: 6),

                _inputField(
                  icon: Icons.phone,
                  hint: "+91 984012345",
                ),

                const SizedBox(height: 18),

                /// 🔹 PASSWORD LABEL
                _label("PASSWORD"),
                const SizedBox(height: 6),

                _inputField(
                  icon: Icons.lock,
                  hint: "Password",
                  isPassword: true,
                  suffix: Icons.visibility_off,
                ),

                const SizedBox(height: 10),

                /// 🔹 FORGOT PASSWORD
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Colors.brown.shade400,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// 🔹 SIGN IN BUTTON (PILL)
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6F4E37),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SizedBox(width: 24),
                        Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: Color(0xFF6F4E37),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// 🔹 SIGN UP TEXT
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            color: Color(0xFF6F4E37),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// =======================================================
/// 🔹 LABEL
// =======================================================
Widget _label(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    ),
  );
}

/// =======================================================
/// 🔹 INPUT FIELD
// =======================================================
Widget _inputField({
  required IconData icon,
  required String hint,
  bool isPassword = false,
  IconData? suffix,
}) {
  return TextField(
    obscureText: isPassword,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      suffixIcon: suffix != null ? Icon(suffix) : null,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
