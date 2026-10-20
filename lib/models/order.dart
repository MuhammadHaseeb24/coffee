import 'cart_item.dart';

class OrderLine {
  final String name;
  final String emoji;
  final String options;
  final int qty;
  final int unitCents;

  const OrderLine({
    required this.name,
    required this.emoji,
    required this.options,
    required this.qty,
    required this.unitCents,
  });

  factory OrderLine.fromCartItem(CartItem i) => OrderLine(
        name: i.product.name,
        emoji: i.product.emoji,
        options: i.optionsLabel,
        qty: i.qty,
        unitCents: i.unitCents,
      );

  Map<String, dynamic> toJson() =>
      {'n': name, 'e': emoji, 'o': options, 'q': qty, 'u': unitCents};

  factory OrderLine.fromJson(Map<String, dynamic> j) => OrderLine(
        name: j['n'] as String,
        emoji: j['e'] as String,
        options: j['o'] as String,
        qty: j['q'] as int,
        unitCents: j['u'] as int,
      );
}

class Order {
  final String id;
  final DateTime date;
  final List<OrderLine> lines;
  final int subtotal;
  final int discount;
  final int tax;
  final int deliveryFee;
  final int total;
  final String mode; // Pickup | Delivery
  final String? promo;

  const Order({
    required this.id,
    required this.date,
    required this.lines,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.mode,
    this.promo,
  });

  int get itemCount => lines.fold(0, (s, l) => s + l.qty);

  /// 0 = preparing, 1 = ready / on the way, 2 = completed.
  /// (Simulated from elapsed time since there is no backend.)
  int get statusStep {
    final m = DateTime.now().difference(date).inMinutes;
    if (m < 2) return 0;
    if (m < 5) return 1;
    return 2;
  }

  String get statusLabel {
    switch (statusStep) {
      case 0:
        return 'Preparing';
      case 1:
        return mode == 'Delivery' ? 'On the way' : 'Ready for pickup';
      default:
        return 'Completed';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.millisecondsSinceEpoch,
        'lines': lines.map((l) => l.toJson()).toList(),
        'sub': subtotal,
        'disc': discount,
        'tax': tax,
        'del': deliveryFee,
        'total': total,
        'mode': mode,
        'promo': promo,
      };

  factory Order.fromJson(Map<String, dynamic> j) => Order(
        id: j['id'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(j['date'] as int),
        lines: (j['lines'] as List)
            .map((e) => OrderLine.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        subtotal: j['sub'] as int,
        discount: j['disc'] as int,
        tax: j['tax'] as int,
        deliveryFee: j['del'] as int,
        total: j['total'] as int,
        mode: j['mode'] as String,
        promo: j['promo'] as String?,
      );
}
