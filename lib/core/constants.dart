import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF6F4E37);
  static const primaryDark = Color(0xFF4E342E);
  static const accent = Color(0xFFC69C6D);
  static const background = Color(0xFFF8F5F2);
  static const textDark = Color(0xFF2C1810);
  static const muted = Color(0xFF8D8680);
  static const danger = Color(0xFFD64545);
  static const success = Color(0xFF3E8E5B);
}

const String kAppName = 'Coffee Taste';

/// Change this to your currency symbol (e.g. 'Rs.' or '€').
const String kCurrency = '\$';

/// Tax applied to (subtotal - discount).
const double kTaxRate = 0.05;

/// Flat delivery fee in cents (200 = 2.00).
const int kDeliveryFeeCents = 200;

/// Promo codes -> percent discount.
const Map<String, int> kPromoCodes = {
  'COFFEE10': 10,
  'WELCOME20': 20,
};

/// Formats cents as currency text, e.g. 450 -> $4.50
String money(int cents) => '$kCurrency${(cents / 100).toStringAsFixed(2)}';
