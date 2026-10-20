import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../models/product.dart';
import '../state/app_state.dart';
import '../core/utils.dart';
import '../widgets/common_widgets.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final String heroTag;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.heroTag,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _size = 1; // Medium
  int _milk = 0;
  int _qty = 1;

  Product get p => widget.product;
  int get _unit => p.priceFor(_size, _milk);
  int get _total => _unit * _qty;

  void _add() {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    AppState.instance.addToCart(
      p,
      sizeIndex: _size,
      milkIndex: _milk,
      qty: _qty,
    );
    navigator.pop();

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('$_qty × ${p.name} added to cart'),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: AppColors.accent,
          onPressed: () {
            navigator.popUntil((r) => r.isFirst);
            ShellNav.tab.value = 2;
          },
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 21, color: color ?? AppColors.textDark),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hero image
          SizedBox(
            height: 360,
            width: double.infinity,
            child: Hero(tag: widget.heroTag, child: ProductImage(product: p)),
          ),

          // Scrollable details sheet
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 310),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 26, 24, 28),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: _details(),
                  ),
                ],
              ),
            ),
          ),

          // Top buttons
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleButton(Icons.arrow_back_ios_new_rounded,
                        () => Navigator.pop(context)),
                    AnimatedBuilder(
                      animation: AppState.instance,
                      builder: (_, __) {
                        final fav = AppState.instance.isFavorite(p.id);
                        return _circleButton(
                          fav ? Icons.favorite : Icons.favorite_border,
                          () => AppState.instance.toggleFavorite(p.id),
                          color: fav ? AppColors.danger : AppColors.textDark,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _details() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            _infoChip(Icons.star_rounded, '${p.rating} (${p.reviews})',
                iconColor: const Color(0xFFFFB300)),
            _infoChip(Icons.local_fire_department_rounded, '${p.calories} kcal',
                iconColor: AppColors.danger),
            _infoChip(Icons.timer_outlined, '5-10 min'),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          p.description,
          style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
        ),
        const SizedBox(height: 26),
        _title('Size'),
        const SizedBox(height: 12),
        Row(
          children: [
            for (int i = 0; i < kSizes.length; i++) ...[
              Expanded(child: _sizeTile(i)),
              if (i != kSizes.length - 1) const SizedBox(width: 12),
            ],
          ],
        ),
        if (p.milkOptions) ...[
          const SizedBox(height: 26),
          _title('Milk'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (int i = 0; i < kMilks.length; i++) _milkChip(i),
            ],
          ),
        ],
        const SizedBox(height: 26),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _title('Quantity'),
            QtyStepper(
              value: _qty,
              onMinus: () {
                if (_qty > 1) setState(() => _qty--);
              },
              onPlus: () {
                if (_qty < 20) setState(() => _qty++);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _title(String t) => Text(
        t,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      );

  Widget _infoChip(IconData icon, String text, {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor ?? AppColors.muted),
          const SizedBox(width: 5),
          Text(text,
              style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _sizeTile(int i) {
    final selected = _size == i;
    final s = kSizes[i];
    return GestureDetector(
      onTap: () => setState(() => _size = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Text(
              s.label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${s.ml} ml',
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.white70 : AppColors.muted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              money(p.priceFor(i, _milk)),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _milkChip(int i) {
    final selected = _milk == i;
    final m = kMilks[i];
    return ChoiceChip(
      showCheckmark: false,
      selected: selected,
      onSelected: (_) => setState(() => _milk = i),
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: selected ? AppColors.primary : Colors.grey.shade300,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      label: Text(
        m.extraCents == 0 ? m.name : '${m.name} +${money(m.extraCents)}',
        style: TextStyle(
          color: selected ? Colors.white : AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Total',
                      style: TextStyle(color: AppColors.muted, fontSize: 12)),
                  Text(
                    money(_total),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: PrimaryButton(label: 'Add to Cart', onTap: _add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
