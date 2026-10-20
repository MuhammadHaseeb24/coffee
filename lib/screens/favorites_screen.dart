import 'package:flutter/material.dart';

import '../core/utils.dart';
import '../data/menu.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        automaticallyImplyLeading: false,
      ),
      body: AnimatedBuilder(
        animation: AppState.instance,
        builder: (context, _) {
          final favs = kMenu
              .where((p) => AppState.instance.isFavorite(p.id))
              .toList();

          if (favs.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'No favorites yet',
              message: 'Tap the heart on any drink to save it here.',
              buttonLabel: 'Browse menu',
              onButton: () => ShellNav.tab.value = 0,
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            itemCount: favs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 282,
            ),
            itemBuilder: (_, i) =>
                ProductCard(product: favs[i], heroPrefix: 'fav'),
          );
        },
      ),
    );
  }
}
