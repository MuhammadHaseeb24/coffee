import 'package:flutter/material.dart';
import 'constants.dart';

/// Lets any screen switch the bottom-navigation tab.
/// 0 = Home, 1 = Favorites, 2 = Cart, 3 = Profile
class ShellNav {
  static final ValueNotifier<int> tab = ValueNotifier<int>(0);
}

Route<T> fadeRoute<T>(Widget page, {int ms = 500}) {
  return PageRouteBuilder<T>(
    transitionDuration: Duration(milliseconds: ms),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
  );
}

void showToast(
  BuildContext context,
  String message, {
  String? actionLabel,
  VoidCallback? onAction,
  bool error = false,
}) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: error ? AppColors.danger : AppColors.textDark,
      duration: const Duration(seconds: 3),
      action: actionLabel == null
          ? null
          : SnackBarAction(
              label: actionLabel,
              textColor: AppColors.accent,
              onPressed: onAction ?? () {},
            ),
    ),
  );
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String formatDate(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final mm = d.minute.toString().padLeft(2, '0');
  final ampm = d.hour >= 12 ? 'PM' : 'AM';
  return '${d.day} ${_months[d.month - 1]} ${d.year}, $h:$mm $ampm';
}

class Validators {
  static String? name(String? v) {
    if (v == null || v.trim().length < 2) return 'Enter your full name';
    return null;
  }

  static String? phone(String? v) {
    final digits = (v ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 7 || digits.length > 15) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.length < 6) return 'Use at least 6 characters';
    return null;
  }
}
