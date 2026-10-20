import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_card.dart';

/// Full grid for a "See all" section.
class ProductListScreen extends StatelessWidget {
  final String title;
  final List<Product> products;
  const ProductListScreen({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 282,
        ),
        itemBuilder: (_, i) =>
            ProductCard(product: products[i], heroPrefix: 'list'),
      ),
    );
  }
}
