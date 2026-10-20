import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../models/order.dart';
import '../widgets/common_widgets.dart';
import 'orders_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final Order order;
  const OrderSuccessScreen({super.key, required this.order});

  void _home(BuildContext context) {
    Navigator.popUntil(context, (r) => r.isFirst);
    ShellNav.tab.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success.withOpacity(0.12),
                  ),
                  child: const Icon(Icons.check_circle_rounded,
                      size: 80, color: AppColors.success),
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Order placed!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                order.mode == 'Delivery'
                    ? 'Your drinks will arrive in about 25-30 minutes.'
                    : 'Your drinks will be ready for pickup in 10-15 minutes.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted, height: 1.4),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _line('Order ID', '#${order.id}'),
                    _line('Type', order.mode),
                    _line('Items', '${order.itemCount}'),
                    const Divider(height: 22),
                    _line('Total paid', money(order.total), bold: true),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Track my order',
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OrdersScreen()),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _home(context),
                child: const Text(
                  'Back to home',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _line(String a, String b, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(a,
              style: TextStyle(
                  color: bold ? AppColors.textDark : AppColors.muted,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w400)),
          Text(b,
              style: TextStyle(
                  color: bold ? AppColors.primary : AppColors.textDark,
                  fontSize: bold ? 18 : 14,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }
}
