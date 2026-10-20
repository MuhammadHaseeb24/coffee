import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';

class AppUser {
  final String phone; // normalized digits, used as account id
  String name;
  AppUser(this.phone, this.name);

  String get firstName {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.first.isEmpty ? 'there' : parts.first;
  }

  String get initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

/// Single source of truth for the whole app (auth, favorites, cart, orders).
/// Everything is stored locally with SharedPreferences, per user account.
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  late SharedPreferences _prefs;

  bool seenOnboarding = false;
  AppUser? user;
  final Set<String> favorites = {};
  final List<CartItem> cart = [];
  final List<Order> orders = [];
  String? promoCode;
  bool delivery = false;

  bool get isLoggedIn => user != null;

  // ======================= INIT =======================
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    seenOnboarding = _prefs.getBool('seenOnboarding') ?? false;

    final session = _prefs.getString('session');
    if (session != null) {
      final u = _users()[session];
      if (u != null) {
        user = AppUser(session, u['name'] as String);
        _loadUserData();
      }
    }
  }

  Future<void> completeOnboarding() async {
    seenOnboarding = true;
    await _prefs.setBool('seenOnboarding', true);
  }

  // ======================= AUTH =======================
  static String normalizePhone(String p) => p.replaceAll(RegExp(r'[^0-9]'), '');

  Map<String, dynamic> _users() {
    final raw = _prefs.getString('users');
    if (raw == null) return {};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<void> _saveUsers(Map<String, dynamic> users) =>
      _prefs.setString('users', jsonEncode(users));

  String _salt() {
    final r = Random.secure();
    return base64UrlEncode(List<int>.generate(16, (_) => r.nextInt(256)));
  }

  String _hash(String password, String salt) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  /// Returns an error message, or null on success.
  Future<String?> signUp({
    required String name,
    required String phone,
    required String password,
  }) async {
    final id = normalizePhone(phone);
    final users = _users();
    if (users.containsKey(id)) {
      return 'An account with this phone number already exists.';
    }
    final salt = _salt();
    users[id] = {
      'name': name.trim(),
      'salt': salt,
      'hash': _hash(password, salt),
    };
    await _saveUsers(users);
    await _startSession(id, name.trim());
    return null;
  }

  /// Returns an error message, or null on success.
  Future<String?> signIn({
    required String phone,
    required String password,
  }) async {
    final id = normalizePhone(phone);
    final u = _users()[id];
    if (u == null) return 'No account found for this phone number.';
    final ok = _hash(password, u['salt'] as String) == u['hash'];
    if (!ok) return 'Incorrect password. Please try again.';
    await _startSession(id, u['name'] as String);
    return null;
  }

  /// Returns an error message, or null on success.
  Future<String?> resetPassword({
    required String phone,
    required String newPassword,
  }) async {
    final id = normalizePhone(phone);
    final users = _users();
    final u = users[id];
    if (u == null) return 'No account found for this phone number.';
    final salt = _salt();
    users[id] = {
      'name': u['name'],
      'salt': salt,
      'hash': _hash(newPassword, salt),
    };
    await _saveUsers(users);
    return null;
  }

  Future<void> _startSession(String id, String name) async {
    user = AppUser(id, name);
    await _prefs.setString('session', id);
    _loadUserData();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _prefs.remove('session');
    user = null;
    favorites.clear();
    cart.clear();
    orders.clear();
    promoCode = null;
    delivery = false;
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    final u = user;
    if (u == null) return;
    final users = _users();
    if (users[u.phone] != null) {
      users[u.phone]['name'] = name.trim();
      await _saveUsers(users);
    }
    u.name = name.trim();
    notifyListeners();
  }

  // ======================= PERSISTENCE =======================
  void _loadUserData() {
    final id = user!.phone;

    favorites
      ..clear()
      ..addAll(_prefs.getStringList('fav_$id') ?? const <String>[]);

    cart.clear();
    final cartRaw = _prefs.getString('cart_$id');
    if (cartRaw != null) {
      for (final m in jsonDecode(cartRaw) as List) {
        final item = CartItem.fromJson(Map<String, dynamic>.from(m as Map));
        if (item != null) cart.add(item);
      }
    }

    orders.clear();
    final ordersRaw = _prefs.getString('orders_$id');
    if (ordersRaw != null) {
      for (final m in jsonDecode(ordersRaw) as List) {
        orders.add(Order.fromJson(Map<String, dynamic>.from(m as Map)));
      }
    }

    promoCode = null;
    delivery = false;
  }

  void _saveFavorites() =>
      _prefs.setStringList('fav_${user!.phone}', favorites.toList());

  void _saveCart() => _prefs.setString(
      'cart_${user!.phone}', jsonEncode(cart.map((c) => c.toJson()).toList()));

  void _saveOrders() => _prefs.setString('orders_${user!.phone}',
      jsonEncode(orders.map((o) => o.toJson()).toList()));

  // ======================= FAVORITES =======================
  bool isFavorite(String productId) => favorites.contains(productId);

  void toggleFavorite(String productId) {
    if (!favorites.remove(productId)) favorites.add(productId);
    _saveFavorites();
    notifyListeners();
  }

  // ======================= CART =======================
  int get cartCount => cart.fold(0, (s, i) => s + i.qty);

  void addToCart(
    Product product, {
    required int sizeIndex,
    required int milkIndex,
    int qty = 1,
  }) {
    final item = CartItem(
      product: product,
      sizeIndex: sizeIndex,
      milkIndex: milkIndex,
      qty: qty,
    );
    final existing = cart.where((c) => c.key == item.key);
    if (existing.isNotEmpty) {
      existing.first.qty += qty;
    } else {
      cart.add(item);
    }
    _saveCart();
    notifyListeners();
  }

  void changeQty(CartItem item, int delta) {
    item.qty += delta;
    if (item.qty <= 0) cart.remove(item);
    _saveCart();
    notifyListeners();
  }

  int removeItem(CartItem item) {
    final index = cart.indexOf(item);
    cart.remove(item);
    _saveCart();
    notifyListeners();
    return index;
  }

  void restoreItem(int index, CartItem item) {
    cart.insert(index.clamp(0, cart.length), item);
    _saveCart();
    notifyListeners();
  }

  // ---- promo & delivery ----
  bool applyPromo(String code) {
    final c = code.trim().toUpperCase();
    if (!kPromoCodes.containsKey(c)) return false;
    promoCode = c;
    notifyListeners();
    return true;
  }

  void removePromo() {
    promoCode = null;
    notifyListeners();
  }

  void setDelivery(bool value) {
    delivery = value;
    notifyListeners();
  }

  // ---- totals (all in cents) ----
  int get subtotal => cart.fold(0, (s, i) => s + i.totalCents);

  int get discount => promoCode == null
      ? 0
      : (subtotal * (kPromoCodes[promoCode] ?? 0) / 100).round();

  int get tax => ((subtotal - discount) * kTaxRate).round();

  int get deliveryFee => (delivery && cart.isNotEmpty) ? kDeliveryFeeCents : 0;

  int get total => subtotal - discount + tax + deliveryFee;

  // ======================= ORDERS =======================
  Order placeOrder() {
    final order = Order(
      id: 'CT${1000 + Random().nextInt(9000)}',
      date: DateTime.now(),
      lines: cart.map(OrderLine.fromCartItem).toList(),
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      deliveryFee: deliveryFee,
      total: total,
      mode: delivery ? 'Delivery' : 'Pickup',
      promo: promoCode,
    );
    orders.insert(0, order);
    cart.clear();
    promoCode = null;
    _saveCart();
    _saveOrders();
    notifyListeners();
    return order;
  }
}
