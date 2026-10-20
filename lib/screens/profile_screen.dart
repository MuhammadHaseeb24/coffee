import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';
import 'orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _editName(BuildContext context) async {
    final controller =
        TextEditingController(text: AppState.instance.user?.name ?? '');
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Edit name',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Form(
          key: formKey,
          child: AppTextField(
            controller: controller,
            label: 'Full name',
            hint: 'Your name',
            icon: Icons.person,
            validator: Validators.name,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(ctx, true);
            },
            child: const Text('Save',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (saved == true) {
      await AppState.instance.updateName(controller.text);
      if (context.mounted) showToast(context, 'Name updated');
    }
    controller.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Log out?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('You can sign back in anytime.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log out',
                style: TextStyle(
                    color: AppColors.danger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (ok != true) return;

    await AppState.instance.signOut();
    if (!context.mounted) return;
    ShellNav.tab.value = 0;
    Navigator.of(context).pushAndRemoveUntil(
      fadeRoute(const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: AnimatedBuilder(
        animation: AppState.instance,
        builder: (context, _) {
          final s = AppState.instance;
          final u = s.user;

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              // Header card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.18),
                        border: Border.all(color: Colors.white54, width: 2),
                      ),
                      child: Text(
                        u?.initials ?? '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            u?.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            u == null ? '' : '+${u.phone}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Stats
              Row(
                children: [
                  _stat('Orders', '${s.orders.length}', Icons.receipt_long),
                  const SizedBox(width: 12),
                  _stat('Favorites', '${s.favorites.length}',
                      Icons.favorite_rounded),
                  const SizedBox(width: 12),
                  _stat('In cart', '${s.cartCount}',
                      Icons.shopping_bag_rounded),
                ],
              ),
              const SizedBox(height: 22),

              _tile(Icons.receipt_long_outlined, 'My orders', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrdersScreen()),
                );
              }),
              _tile(Icons.favorite_border, 'My favorites',
                  onTap: () => ShellNav.tab.value = 1),
              _tile(Icons.edit_outlined, 'Edit name',
                  onTap: () => _editName(context)),
              _tile(Icons.local_offer_outlined, 'Promo codes', onTap: () {
                showToast(context,
                    'Try ${kPromoCodes.keys.join(' or ')} in your cart');
              }),
              _tile(Icons.info_outline, 'About', onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: kAppName,
                  applicationVersion: '1.0.0',
                  applicationIcon: const CoffeeLogo(size: 44),
                  children: const [
                    SizedBox(height: 12),
                    Text('A coffee ordering app built with Flutter.'),
                  ],
                );
              }),
              const SizedBox(height: 8),
              _tile(Icons.logout_rounded, 'Log out',
                  color: AppColors.danger, onTap: () => _logout(context)),
            ],
          );
        },
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            Text(label,
                style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String title,
      {required VoidCallback onTap, Color? color}) {
    final c = color ?? AppColors.textDark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (color ?? AppColors.primary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color ?? AppColors.primary, size: 22),
        ),
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.w600, color: c)),
        trailing: Icon(Icons.chevron_right_rounded,
            color: color ?? AppColors.muted),
      ),
    );
  }
}
