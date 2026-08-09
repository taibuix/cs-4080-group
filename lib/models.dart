enum Category {
  all('All products'),
  workspace('Workspace'),
  audio('Audio'),
  lifestyle('Lifestyle');

  const Category(this.label);
  final String label;
}

extension type const ProductId(String value) implements String {}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.color,
    required this.rating,
    this.isNew = false,
  });

  final ProductId id;
  final String name;
  final String tagline;
  final String description;
  final int price;
  final Category category;
  final String image;
  final int color;
  final double rating;
  final bool isNew;
}

class CartLine {
  const CartLine(this.product, this.quantity);
  final Product product;
  final int quantity;

  CartLine copyWith({int? quantity}) =>
      CartLine(product, quantity ?? this.quantity);
  int get total => product.price * quantity;
}

typedef PriceSummary = ({int subtotal, int discount, int shipping, int total});

sealed class CheckoutResult {
  const CheckoutResult();
}

final class CheckoutSuccess extends CheckoutResult {
  const CheckoutSuccess(this.orderNumber);
  final String orderNumber;
}

final class CheckoutFailure extends CheckoutResult {
  const CheckoutFailure(this.message);
  final String message;
}

extension CurrencyFormatting on int {
  String get usd => '\$${toStringAsFixed(2)}';
}
