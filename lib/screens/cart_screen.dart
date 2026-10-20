import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../models/cart_item.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import 'order_success_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promo = TextEditingController();
  bool _placing = false;

  @override
  void dispose() {
    _promo.dispose();
    super.dispose();
  }

  void _applyPromo() {
    FocusScope.of(context).unfocus();
    final ok = AppState.instance.applyPromo(_promo.text);
    if (ok) {
      _promo.clear();
      showToast(context, 'Promo code applied');
    } else {
      showToast(context, 'Invalid promo code', error: true);
    }
  }

  Future<void> _checkout() async {
    setState(() => _placing = true);
    await Future.delayed(const Duration(milliseconds: 800)); // fake payment
    final order = AppState.instance.placeOrder();
    if (!mounted) return;
    setState(() => _placing = false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        automaticallyImplyLeading: false,
      ),
      body: AnimatedBuilder(
        animation: AppState.instance,
        builder: (context, _) {
          final s = AppState.instance;

          if (s.cart.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              message: 'Add your favorite drinks and they will show up here.',
              buttonLabel: 'Browse menu',
              onButton: () => ShellNav.tab.value = 0,
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [
                    for (final item in List<CartItem>.from(s.cart)) ...[
                      _cartTile(item),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 10),
                    _modeToggle(s),
                    const SizedBox(height: 18),
                    _promoBox(s),
                  ],
                ),
              ),
              _summary(s),
            ],
          );
        },
      ),
    );
  }

  // ---------------- item tile ----------------
  Widget _cartTile(CartItem item) {
    return Dismissible(
      key: ValueKey(item.key),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) {
        final idx = AppState.instance.removeItem(item);
        showToast(
          context,
          '${item.product.name} removed',
          actionLabel: 'UNDO',
          onAction: () => AppState.instance.restoreItem(idx, item),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 74,
                height: 74,
                child: ProductImage(product: item.product),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.optionsLabel,
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    money(item.totalCents),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            QtyStepper(
              value: item.qty,
              onMinus: () => AppState.instance.changeQty(item, -1),
              onPlus: () => AppState.instance.changeQty(item, 1),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- pickup / delivery ----------------
  Widget _modeToggle(AppState s) {
    Widget option(String label, IconData icon, bool value) {
      final selected = s.delivery == value;
      return Expanded(
        child: GestureDetector(
          onTap: () => s.setDelivery(value),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 20,
                    color: selected ? Colors.white : AppColors.muted),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order type',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
        const SizedBox(height: 10),
        Row(
          children: [
            option('Pickup', Icons.storefront_outlined, false),
            const SizedBox(width: 12),
            option('Delivery +${money(kDeliveryFeeCents)}',
                Icons.delivery_dining_outlined, true),
          ],
        ),
      ],
    );
  }

  // ---------------- promo ----------------
  Widget _promoBox(AppState s) {
    if (s.promoCode != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.success.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_offer_rounded,
                color: AppColors.success, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${s.promoCode} applied (${kPromoCodes[s.promoCode]}% off)',
                style: const TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: s.removePromo,
              child: const Icon(Icons.close, color: AppColors.success),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _promo,
            textCapitalization: TextCapitalization.characters,
            onSubmitted: (_) => _applyPromo(),
            decoration: InputDecoration(
              hintText: 'Promo code (try COFFEE10)',
              prefixIcon: const Icon(Icons.local_offer_outlined),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _applyPromo,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Apply'),
          ),
        ),
      ],
    );
  }

  // ---------------- totals ----------------
  Widget _row(String label, String value,
      {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: bold ? 17 : 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.w400,
              color: color ?? (bold ? AppColors.textDark : AppColors.muted),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 20 : 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: color ?? (bold ? AppColors.primary : AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(AppState s) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row('Subtotal', money(s.subtotal)),
          if (s.discount > 0)
            _row('Discount', '-${money(s.discount)}', color: AppColors.success),
          _row('Tax (${(kTaxRate * 100).round()}%)', money(s.tax)),
          if (s.deliveryFee > 0) _row('Delivery', money(s.deliveryFee)),
          const Divider(height: 18),
          _row('Total', money(s.total), bold: true),
          const SizedBox(height: 10),
          PrimaryButton(
            label: 'Checkout',
            onTap: _checkout,
            loading: _placing,
          ),
        ],
      ),
    );
  }
}
