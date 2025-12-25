import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6F4E37),
        scaffoldBackgroundColor: const Color(0xFFF8F5F2),
        fontFamily: 'Inter',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP BAR WITH AVATAR AND MENU
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // AVATAR WITH NETWORK IMAGE
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6F4E37),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 20,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 24,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // GREETING SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hi, Haseeb",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C1810),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Coffee shop, beer & wine..",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // SEARCH BAR SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.grey[500],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Search coffee, tea, or beer",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6F4E37),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6F4E37).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // CATEGORIES SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      CategoryChip(title: "☕ Coffee", selected: true),
                      CategoryChip(title: "🍺 Beer"),
                      CategoryChip(title: "🍷 Wine Bar"),
                      CategoryChip(title: "🥤 Smoothies"),
                      CategoryChip(title: "🧋 Bubble Tea"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // POPULAR BEVERAGES SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Popular Beverages",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C1810),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6F4E37).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "See all",
                          style: TextStyle(
                            color: const Color(0xFF6F4E37),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // POPULAR BEVERAGES LIST
              SizedBox(
                height: 280,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  children: const [
                    BeverageCard(
                      title: "Chai Latte",
                      price: "\$5.20",
                      description: "Spiced tea with steamed milk",
                      imageUrl: "https://images.unsplash.com/photo-1568649929103-28ffbefaca1e?w=400&h=300&fit=crop",
                    ),
                    SizedBox(width: 16),
                    BeverageCard(
                      title: "Matcha Latte",
                      price: "\$6.20",
                      description: "Japanese green tea with milk",
                      imageUrl: "https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400&h=300&fit=crop",
                    ),
                    SizedBox(width: 16),
                    BeverageCard(
                      title: "Red Eye Coffee",
                      price: "\$4.80",
                      description: "Drip coffee with espresso shot",
                      imageUrl: "https://images.unsplash.com/photo-1511537190424-bbbab87ac5eb?w-400&h=300&fit=crop",
                    ),
                    SizedBox(width: 16),
                    BeverageCard(
                      title: "Cappuccino",
                      price: "\$4.50",
                      description: "Espresso with steamed milk foam",
                      imageUrl: "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=400&h=300&fit=crop",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // FROZEN BEVERAGES SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Frozen Beverages",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C1810),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6F4E37).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "See all",
                          style: TextStyle(
                            color: const Color(0xFF6F4E37),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // FROZEN BEVERAGES LIST
              SizedBox(
                height: 280,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  children: const [
                    BeverageCard(
                      title: "Iced Caramel Macchiato",
                      price: "\$5.75",
                      description: "Iced coffee with caramel drizzle",
                      imageUrl: "https://images.unsplash.com/photo-1478369402113-1fd53f17e8b4?w=400&h=300&fit=crop",
                    ),
                    SizedBox(width: 16),
                    BeverageCard(
                      title: "Strawberry Frappuccino",
                      price: "\$6.50",
                      description: "Blended strawberry cream drink",
                      imageUrl: "https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=400&h=300&fit=crop",
                    ),
                    SizedBox(width: 16),
                    BeverageCard(
                      title: "Mocha Freeze",
                      price: "\$5.95",
                      description: "Chocolate coffee blended ice",
                      imageUrl: "https://images.unsplash.com/photo-1544148103-0773bf10d330?w=400&h=300&fit=crop",
                    ),
                    SizedBox(width: 16),
                    BeverageCard(
                      title: "Vanilla Bean Cooler",
                      price: "\$5.25",
                      description: "Creamy vanilla blended beverage",
                      imageUrl: "https://images.unsplash.com/photo-1519861531473-920034658307?w=400&h=300&fit=crop",
                    ),
                  ],
                ),
              ),

              // BOTTOM SPACING
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home_filled, "Home", true),
              _buildNavItem(Icons.favorite_border, "Favorites", false),
              _buildCartNavItem(),
              _buildNavItem(Icons.person_outline, "Profile", false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF6F4E37) : Colors.grey[600],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF6F4E37) : Colors.grey[600],
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildCartNavItem() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              color: Colors.grey[600],
              size: 24,
            ),
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF6F4E37),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "3",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "Cart",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String title;
  final bool selected;

  const CategoryChip({
    super.key,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF6F4E37) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: selected ? const Color(0xFF6F4E37) : Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: selected
            ? [
          BoxShadow(
            color: const Color(0xFF6F4E37).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF2C1810),
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}

class BeverageCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final String imageUrl;

  const BeverageCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE SECTION
          Container(
            height: 140,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                      color: const Color(0xFF6F4E37),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF5F0EB),
                    child: const Center(
                      child: Icon(
                        Icons.coffee,
                        size: 60,
                        color: Color(0xFFD7CCC8),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // CONTENT SECTION
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C1810),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6F4E37),
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6F4E37),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}