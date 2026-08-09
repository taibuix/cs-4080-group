import 'package:flutter/material.dart';

import 'models.dart';
import 'store.dart';

void main() => runApp(const NovaShopApp());

class NovaShopApp extends StatefulWidget {
  const NovaShopApp({super.key});

  @override
  State<NovaShopApp> createState() => _NovaShopAppState();
}

class _NovaShopAppState extends State<NovaShopApp> {
  final store = ShopStore();

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Nova Market',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF7F7F5),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7657D5),
            brightness: Brightness.light,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 64,
              height: .98,
              fontWeight: FontWeight.w800,
              letterSpacing: -3,
            ),
            headlineLarge: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
            ),
            titleLarge: TextStyle(fontWeight: FontWeight.w700),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        home: Storefront(store: store),
      );
}

class Storefront extends StatelessWidget {
  const Storefront({required this.store, super.key});
  final ShopStore store;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) => Scaffold(
          endDrawer: CartDrawer(store: store),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFFF7F7F5).withOpacity(.94),
                surfaceTintColor: Colors.transparent,
                toolbarHeight: 76,
                titleSpacing: 28,
                title: const Row(
                  children: [
                    NovaMark(),
                    SizedBox(width: 12),
                    Text(
                      'NOVA',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => _scrollMessage(context),
                    child: const Text('Our story'),
                  ),
                  const SizedBox(width: 8),
                  Builder(
                    builder: (context) => Badge(
                      isLabelVisible: store.itemCount > 0,
                      label: Text('${store.itemCount}'),
                      child: IconButton.filled(
                        tooltip: 'Open cart',
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                        icon: const Icon(Icons.shopping_bag_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              SliverToBoxAdapter(child: _Hero(store: store)),
              SliverToBoxAdapter(child: _CatalogControls(store: store)),
              _ProductGrid(store: store),
              const SliverToBoxAdapter(child: _PromiseStrip()),
              const SliverToBoxAdapter(child: _Footer()),
            ],
          ),
        ),
      );

  void _scrollMessage(BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thoughtful objects for calmer, better days.'),
        ),
      );
}

class NovaMark extends StatelessWidget {
  const NovaMark({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: Color(0xFF18181B),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
      );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.store});
  final ShopStore store;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(28, 44, 28, 52),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: LayoutBuilder(
              builder: (context, size) {
                final compact = size.maxWidth < 760;
                final copy = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'NEW COLLECTION',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF7657D5),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Objects for a\nbetter everyday.',
                      style: compact
                          ? Theme.of(context).textTheme.headlineLarge
                          : Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Useful, beautiful essentials—chosen to make your space feel lighter and your routines work better.',
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.55,
                        color: Color(0xFF61616A),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      onPressed: () => store.selectCategory(Category.all),
                      icon: const Icon(Icons.arrow_downward),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('Shop the collection'),
                      ),
                    ),
                  ],
                );
                final art = Container(
                  height: compact ? 310 : 430,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE7DDF8), Color(0xFFF4CFC2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      Text('🎧', style: TextStyle(fontSize: 150)),
                      Positioned(
                        top: 24,
                        right: 24,
                        child: _Pill(label: 'Free shipping over \$150'),
                      ),
                      Positioned(
                        bottom: 24,
                        left: 24,
                        child: _Pill(label: '★ 4.9 customer favorite'),
                      ),
                    ],
                  ),
                );
                return compact
                    ? Column(children: [copy, const SizedBox(height: 36), art])
                    : Row(
                        children: [
                          Expanded(child: copy),
                          const SizedBox(width: 54),
                          Expanded(child: art),
                        ],
                      );
              },
            ),
          ),
        ),
      );
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.9),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      );
}

class _CatalogControls extends StatelessWidget {
  const _CatalogControls({required this.store});
  final ShopStore store;

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 28, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shop all',
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final category in Category.values)
                      ChoiceChip(
                        label: Text(category.label),
                        selected: store.category == category,
                        onSelected: (_) => store.selectCategory(category),
                      ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 260,
                      child: TextField(
                        onChanged: store.search,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search products…',
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.store});
  final ShopStore store;

  @override
  Widget build(BuildContext context) {
    if (store.visibleProducts.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Center(
            child: Text('No products found. Try a different search.'),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 80),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.crossAxisExtent;
          final columns = width >= 1100
              ? 3
              : width >= 650
                  ? 2
                  : 1;
          return SliverGrid.builder(
            itemCount: store.visibleProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 22,
              mainAxisSpacing: 22,
              childAspectRatio: columns == 1 ? 1.12 : .78,
            ),
            itemBuilder: (context, index) => _ProductCard(
              product: store.visibleProducts[index],
              store: store,
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  const _ProductCard({required this.product, required this.store});
  final Product product;
  final ShopStore store;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedScale(
        scale: hovered ? 1.015 : 1,
        duration: const Duration(milliseconds: 180),
        child: Card(
          elevation: 0,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: InkWell(
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) =>
                  ProductDialog(product: product, store: widget.store),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Color(product.color),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        product.image.startsWith('assets/')
                            ? Image.asset(
                                product.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Text(
                                product.image,
                                style: const TextStyle(fontSize: 92),
                              ),
                        if (product.isNew)
                          const Positioned(
                            top: 16,
                            left: 16,
                            child: _Pill(label: 'NEW'),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              product.tagline,
                              style: const TextStyle(color: Color(0xFF71717A)),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              product.price.usd,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filled(
                        tooltip: 'Add to cart',
                        onPressed: () {
                          widget.store.add(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDialog extends StatelessWidget {
  const ProductDialog({required this.product, required this.store, super.key});
  final Product product;
  final ShopStore store;

  @override
  Widget build(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: LayoutBuilder(
              builder: (context, size) {
                final image = Container(
                  height: 260,
                  decoration: BoxDecoration(
                    color: Color(product.color),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: product.image.startsWith('assets/')
                        ? Image.asset(product.image, fit: BoxFit.cover)
                        : Text(
                            product.image,
                            style: const TextStyle(fontSize: 92),
                          ),
                  ),
                );
                final details = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '★ ${product.rating}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7657D5),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF61616A),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          product.price.usd,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: () {
                            store.add(product);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Add to cart'),
                        ),
                      ],
                    ),
                  ],
                );
                return size.maxWidth < 580
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            image,
                            const SizedBox(height: 24),
                            details
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(child: image),
                          const SizedBox(width: 28),
                          Expanded(child: details),
                        ],
                      );
              },
            ),
          ),
        ),
      );
}

class CartDrawer extends StatefulWidget {
  const CartDrawer({required this.store, super.key});
  final ShopStore store;

  @override
  State<CartDrawer> createState() => _CartDrawerState();
}

class _CartDrawerState extends State<CartDrawer> {
  final promo = TextEditingController();
  String? promoMessage;

  @override
  void dispose() {
    promo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: widget.store,
        builder: (context, _) {
          final pricing = widget.store.pricing;
          return Drawer(
            width: MediaQuery.sizeOf(context).width.clamp(320, 440).toDouble(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Your cart',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (widget.store.cart.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 54,
                                color: Color(0xFFA1A1AA),
                              ),
                              SizedBox(height: 16),
                              Text('Your cart is ready for something good.'),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      Expanded(
                        child: ListView.separated(
                          itemCount: widget.store.cart.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 30),
                          itemBuilder: (context, index) {
                            final line = widget.store.cart[index];
                            return Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Color(line.product.color),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      line.product.image,
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        line.product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(line.product.price.usd),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                widget.store.setQuantity(
                                              line.product.id,
                                              line.quantity - 1,
                                            ),
                                            visualDensity:
                                                VisualDensity.compact,
                                            icon: const Icon(
                                              Icons.remove,
                                              size: 18,
                                            ),
                                          ),
                                          Text('${line.quantity}'),
                                          IconButton(
                                            onPressed: () =>
                                                widget.store.setQuantity(
                                              line.product.id,
                                              line.quantity + 1,
                                            ),
                                            visualDensity:
                                                VisualDensity.compact,
                                            icon:
                                                const Icon(Icons.add, size: 18),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  line.total.usd,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: promo,
                              decoration: const InputDecoration(
                                hintText: 'Promo code',
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: () {
                              final success =
                                  widget.store.applyPromo(promo.text);
                              setState(
                                () => promoMessage = success
                                    ? '10% discount applied!'
                                    : 'Try WELCOME10',
                              );
                            },
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                      if (promoMessage case final message?)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            message,
                            style: TextStyle(
                              color: widget.store.promoApplied
                                  ? Colors.green.shade700
                                  : Colors.orange.shade800,
                            ),
                          ),
                        ),
                      const SizedBox(height: 22),
                      _PriceRow(label: 'Subtotal', value: pricing.subtotal.usd),
                      if (pricing.discount > 0)
                        _PriceRow(
                          label: 'Discount',
                          value: '-${pricing.discount.usd}',
                          color: Colors.green.shade700,
                        ),
                      _PriceRow(
                        label: 'Shipping',
                        value: pricing.shipping == 0
                            ? 'Free'
                            : pricing.shipping.usd,
                      ),
                      const Divider(height: 26),
                      _PriceRow(
                        label: 'Total',
                        value: pricing.total.usd,
                        bold: true,
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: widget.store.checkingOut
                              ? null
                              : () => _showCheckout(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              widget.store.checkingOut
                                  ? 'Processing…'
                                  : 'Secure checkout',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      );

  Future<void> _showCheckout(BuildContext drawerContext) async {
    final email = TextEditingController();
    await showDialog<void>(
      context: drawerContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Complete your order'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email address'),
              ),
              const SizedBox(height: 14),
              const Text(
                'This is a demo checkout. No payment information is collected.',
                style: TextStyle(color: Color(0xFF71717A)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final result = await widget.store.checkout(email: email.text);
              if (!dialogContext.mounted) return;
              Navigator.pop(dialogContext);
              switch (result) {
                case CheckoutSuccess(:final orderNumber):
                  await showDialog<void>(
                    context: drawerContext,
                    builder: (_) => AlertDialog(
                      icon: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 52,
                      ),
                      title: const Text('Order confirmed!'),
                      content: Text(
                        'Thanks for shopping with Nova.\nYour order number is $orderNumber.',
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        FilledButton(
                          onPressed: () => Navigator.pop(drawerContext),
                          child: const Text('Continue shopping'),
                        ),
                      ],
                    ),
                  );
                  if (drawerContext.mounted) Navigator.pop(drawerContext);
                  return;
                case CheckoutFailure(:final message):
                  ScaffoldMessenger.of(
                    drawerContext,
                  ).showSnackBar(SnackBar(content: Text(message)));
                  return;
              }
            },
            child: const Text('Place demo order'),
          ),
        ],
      ),
    );
    email.dispose();
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.color,
  });
  final String label;
  final String value;
  final bool bold;
  final Color? color;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: bold ? FontWeight.w800 : null),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                fontSize: bold ? 20 : null,
                color: color,
              ),
            ),
          ],
        ),
      );
}

class _PromiseStrip extends StatelessWidget {
  const _PromiseStrip();
  @override
  Widget build(BuildContext context) => Container(
        color: const Color(0xFF18181B),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 42),
        child: const Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: 50,
          runSpacing: 28,
          children: [
            _Promise(
              icon: Icons.local_shipping_outlined,
              title: 'Free shipping',
              detail: 'On orders over \$150',
            ),
            _Promise(
              icon: Icons.restart_alt,
              title: '30-day returns',
              detail: 'Simple and stress-free',
            ),
            _Promise(
              icon: Icons.eco_outlined,
              title: 'Lower impact',
              detail: 'Mindful materials',
            ),
          ],
        ),
      );
}

class _Promise extends StatelessWidget {
  const _Promise({
    required this.icon,
    required this.title,
    required this.detail,
  });
  final IconData icon;
  final String title;
  final String detail;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 220,
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFCABCF4), size: 32),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(detail, style: const TextStyle(color: Color(0xFFA1A1AA))),
              ],
            ),
          ],
        ),
      );
}

class _Footer extends StatelessWidget {
  const _Footer();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(36),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NovaMark(),
            SizedBox(width: 12),
            Text('NOVA MARKET  ·  Built with Flutter & Dart'),
          ],
        ),
      );
}
