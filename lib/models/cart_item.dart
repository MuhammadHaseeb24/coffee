import '../data/menu.dart';
import 'product.dart';

class CartItem {
  final Product product;
  final int sizeIndex;
  final int milkIndex;
  int qty;

  CartItem({
    required this.product,
    required this.sizeIndex,
    required this.milkIndex,
    this.qty = 1,
  });

  /// Same drink + same options => same cart line.
  String get key =>
      '${product.id}_${sizeIndex}_${product.milkOptions ? milkIndex : 0}';

  int get unitCents => product.priceFor(sizeIndex, milkIndex);
  int get totalCents => unitCents * qty;

  String get optionsLabel => product.milkOptions
      ? '${kSizes[sizeIndex].label} • ${kMilks[milkIndex].name}'
      : kSizes[sizeIndex].label;

  Map<String, dynamic> toJson() =>
      {'p': product.id, 's': sizeIndex, 'm': milkIndex, 'q': qty};

  static CartItem? fromJson(Map<String, dynamic> j) {
    final p = productById(j['p'] as String);
    if (p == null) return null;
    return CartItem(
      product: p,
      sizeIndex: j['s'] as int,
      milkIndex: j['m'] as int,
      qty: j['q'] as int,
    );
  }
}
