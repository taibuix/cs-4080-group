import 'dart:async';

import 'package:flutter/foundation.dart' hide Category;

import 'catalog.dart';
import 'models.dart';

class ShopStore extends ChangeNotifier {
  final Map<ProductId, CartLine> _cart = {};
  Category _category = Category.all;
  String _query = '';
  bool _promoApplied = false;
  bool _checkingOut = false;

  Category get category => _category;
  String get query => _query;
  bool get promoApplied => _promoApplied;
  bool get checkingOut => _checkingOut;
  List<CartLine> get cart => List.unmodifiable(_cart.values);
  int get itemCount => _cart.values.fold(0, (sum, line) => sum + line.quantity);

  List<Product> get visibleProducts => products.where((product) {
        final categoryMatches =
            _category == Category.all || product.category == _category;
        final text = '${product.name} ${product.tagline}'.toLowerCase();
        return categoryMatches && text.contains(_query.toLowerCase().trim());
      }).toList(growable: false);

  PriceSummary get pricing {
    final subtotal = _cart.values.fold(0, (sum, line) => sum + line.total);
    final discount = _promoApplied ? (subtotal * .1).round() : 0;
    final shipping = subtotal == 0 || subtotal >= 150 ? 0 : 12;
    return (
      subtotal: subtotal,
      discount: discount,
      shipping: shipping,
      total: subtotal - discount + shipping,
    );
  }

  void search(String value) {
    _query = value;
    notifyListeners();
  }

  void selectCategory(Category value) {
    _category = value;
    notifyListeners();
  }

  void add(Product product) {
    _cart.update(
      product.id,
      (line) => line.copyWith(quantity: line.quantity + 1),
      ifAbsent: () => CartLine(product, 1),
    );
    notifyListeners();
  }

  void setQuantity(ProductId id, int quantity) {
    if (quantity <= 0) {
      _cart.remove(id);
    } else if (_cart[id] case final line?) {
      _cart[id] = line.copyWith(quantity: quantity);
    }
    notifyListeners();
  }

  bool applyPromo(String code) {
    _promoApplied = code.trim().toUpperCase() == 'WELCOME10';
    notifyListeners();
    return _promoApplied;
  }

  Future<CheckoutResult> checkout({required String email}) async {
    if (_cart.isEmpty) return const CheckoutFailure('Your cart is empty.');
    if (!email.contains('@'))
      return const CheckoutFailure('Enter a valid email address.');

    _checkingOut = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final orderNumber =
        'NOVA-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    _cart.clear();
    _promoApplied = false;
    _checkingOut = false;
    notifyListeners();
    return CheckoutSuccess(orderNumber);
  }
}
