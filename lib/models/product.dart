import 'package:flutter/material.dart';

enum DrinkCategory { coffee, tea, frozen, smoothies, bubbleTea }

extension DrinkCategoryX on DrinkCategory {
  String get label {
    switch (this) {
      case DrinkCategory.coffee:
        return 'Coffee';
      case DrinkCategory.tea:
        return 'Tea';
      case DrinkCategory.frozen:
        return 'Frozen';
      case DrinkCategory.smoothies:
        return 'Smoothies';
      case DrinkCategory.bubbleTea:
        return 'Bubble Tea';
    }
  }

  String get emoji {
    switch (this) {
      case DrinkCategory.coffee:
        return '☕';
      case DrinkCategory.tea:
        return '🍵';
      case DrinkCategory.frozen:
        return '🥤';
      case DrinkCategory.smoothies:
        return '🍓';
      case DrinkCategory.bubbleTea:
        return '🧋';
    }
  }

  List<Color> get gradient {
    switch (this) {
      case DrinkCategory.coffee:
        return const [Color(0xFFD7B899), Color(0xFFA9805B)];
      case DrinkCategory.tea:
        return const [Color(0xFFCFE3C0), Color(0xFF8FB574)];
      case DrinkCategory.frozen:
        return const [Color(0xFFC9DFF0), Color(0xFF7FA9CC)];
      case DrinkCategory.smoothies:
        return const [Color(0xFFF6C6C0), Color(0xFFE58E86)];
      case DrinkCategory.bubbleTea:
        return const [Color(0xFFE5D0F0), Color(0xFFB590CF)];
    }
  }
}

class DrinkSize {
  final String label;
  final String name;
  final int ml;
  final int percent; // price multiplier in percent
  const DrinkSize(this.label, this.name, this.ml, this.percent);
}

const List<DrinkSize> kSizes = [
  DrinkSize('S', 'Small', 250, 85),
  DrinkSize('M', 'Medium', 350, 100),
  DrinkSize('L', 'Large', 450, 120),
];

class MilkOption {
  final String name;
  final int extraCents;
  const MilkOption(this.name, this.extraCents);
}

const List<MilkOption> kMilks = [
  MilkOption('Whole milk', 0),
  MilkOption('Oat milk', 50),
  MilkOption('Almond milk', 60),
  MilkOption('Soy milk', 40),
];

class Product {
  final String id;
  final String name;
  final String description;
  final int priceCents; // base price for Medium
  final DrinkCategory category;
  final double rating;
  final int reviews;
  final String emoji;
  final String imageUrl; // empty => gradient + emoji tile
  final bool popular;
  final bool milkOptions;
  final int calories;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.priceCents,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.emoji,
    required this.calories,
    this.imageUrl = '',
    this.popular = false,
    this.milkOptions = false,
  });

  int priceFor(int sizeIndex, int milkIndex) {
    final base = (priceCents * kSizes[sizeIndex].percent / 100).round();
    final extra = milkOptions ? kMilks[milkIndex].extraCents : 0;
    return base + extra;
  }
}
