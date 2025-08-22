import 'package:dotted_line/dotted_line.dart';
import 'package:ecommerce/constants/colors.dart';
import 'package:ecommerce/data/model/basket_item.dart';
import 'package:ecommerce/util/extensions/string_extensions.dart';
import 'package:ecommerce/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  late Box<BasketItem> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<BasketItem>('basketItemBox');
    // Listen to box changes to auto-refresh UI
    box.listenable().addListener(_onBoxChanged);
  }

  @override
  void dispose() {
    box.listenable().removeListener(_onBoxChanged);
    super.dispose();
  }

  void _onBoxChanged() {
    if (mounted) {
      setState(() {
        // This will trigger a rebuild when the box changes
      });
    }
  }

  double get totalPrice {
    return box.values
        .fold(0.0, (sum, item) => sum + (item.realPrice?.toDouble() ?? 0.0));
  }

  int get itemCount {
    return box.values.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundPrimary,
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<BasketItem> box, _) {
          return CustomScrollView(
            slivers: [
              // Modern App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: CustomColors.backgroundPrimary,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            // Shopping Cart Icon
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    CustomColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: CustomColors.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Title and Count
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Shopping Cart',
                                    style: TextStyle(
                                      fontFamily: 'GB',
                                      fontSize: 24,
                                      color: CustomColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                                    style: TextStyle(
                                      fontFamily: 'GM',
                                      fontSize: 16,
                                      color: CustomColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Cart Items or Empty State
              if (itemCount == 0)
                SliverFillRemaining(
                  child: _buildEmptyState(),
                )
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = box.values.toList()[index];
                        return ModernCartItem(
                          basketItem: item,
                          onRemove: () => _removeItem(item),
                          onQuantityChanged: (quantity) =>
                              _updateQuantity(item, quantity),
                        );
                      },
                      childCount: itemCount,
                    ),
                  ),
                ),

                // Order Summary
                SliverToBoxAdapter(
                  child: _buildOrderSummary(),
                ),

                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ],
          );
        },
      ),

      // Floating Checkout Button
      floatingActionButton: itemCount > 0 ? _buildCheckoutButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: CustomColors.cardBackground,
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: CustomColors.textMuted,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontFamily: 'GB',
              fontSize: 24,
              color: CustomColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add some products to get started',
            style: TextStyle(
              fontFamily: 'GM',
              fontSize: 16,
              color: CustomColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          _buildContinueShoppingButton(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CustomColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CustomColors.surfaceColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontFamily: 'GB',
              fontSize: 20,
              color: CustomColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal ($itemCount items)',
                style: TextStyle(
                  fontFamily: 'GM',
                  fontSize: 16,
                  color: CustomColors.textSecondary,
                ),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: 'GB',
                  fontSize: 16,
                  color: CustomColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping',
                style: TextStyle(
                  fontFamily: 'GM',
                  fontSize: 16,
                  color: CustomColors.textSecondary,
                ),
              ),
              Text(
                'Free',
                style: TextStyle(
                  fontFamily: 'GB',
                  fontSize: 16,
                  color: CustomColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: CustomColors.textMuted.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontFamily: 'GB',
                  fontSize: 20,
                  color: CustomColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: 'GB',
                  fontSize: 24,
                  color: CustomColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      width: MediaQuery.of(context).size.width - 48,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CustomColors.primary,
            CustomColors.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CustomColors.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _proceedToCheckout,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.payment_outlined,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'Proceed to Checkout',
                style: TextStyle(
                  fontFamily: 'GB',
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueShoppingButton() {
    return Container(
      width: 200,
      height: 48,
      decoration: BoxDecoration(
        color: CustomColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CustomColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(
            context,
          ),
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              'Continue Shopping',
              style: TextStyle(
                fontFamily: 'GB',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateQuantity(BasketItem item, int quantity) {
    // TODO: Implement quantity update functionality
    // For now, we'll just show a message since the current BasketItem model doesn't support quantity
    setState(() {});
  }

  void _removeItem(BasketItem item) {
    final index =
        box.values.toList().indexWhere((element) => element.id == item.id);
    if (index != -1) {
      box.deleteAt(index);
      // The ValueListenableBuilder will automatically update the UI

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Item removed from cart',
            style: TextStyle(
              fontFamily: 'GM',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          backgroundColor: CustomColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _proceedToCheckout() {
    // TODO: Implement checkout functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Checkout functionality coming soon!',
          style: TextStyle(
            fontFamily: 'GM',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: CustomColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// Modern Cart Item Widget
class ModernCartItem extends StatefulWidget {
  final BasketItem basketItem;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const ModernCartItem({
    super.key,
    required this.basketItem,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  State<ModernCartItem> createState() => _ModernCartItemState();
}

class _ModernCartItemState extends State<ModernCartItem> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CustomColors.surfaceColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main Item Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: CustomColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedImage(
                    imageUrl: widget.basketItem.thumbnail,
                    radius: 16,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.basketItem.name,
                      style: TextStyle(
                        fontFamily: 'GB',
                        fontSize: 18,
                        color: CustomColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CustomColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'In Stock',
                        style: TextStyle(
                          fontFamily: 'GM',
                          fontSize: 12,
                          color: CustomColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Price Row
                    Row(
                      children: [
                        Text(
                          '\$${(widget.basketItem.realPrice?.toDouble() ?? 0.0).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'GB',
                            fontSize: 20,
                            color: CustomColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.basketItem.price >
                            (widget.basketItem.realPrice ?? 0)) ...[
                          const SizedBox(width: 8),
                          Text(
                            '\$${widget.basketItem.price.toDouble().toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: 'GM',
                              fontSize: 14,
                              color: CustomColors.textMuted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: CustomColors.error,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${(((widget.basketItem.price - (widget.basketItem.realPrice ?? 0)) / widget.basketItem.price) * 100).round()}% OFF',
                              style: const TextStyle(
                                fontFamily: 'GB',
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Remove Button
              GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CustomColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: CustomColors.error,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quantity and Actions Row
          Row(
            children: [
              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  color: CustomColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CustomColors.textMuted.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                          widget.onQuantityChanged(quantity);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.remove,
                          color: quantity > 1
                              ? CustomColors.textPrimary
                              : CustomColors.textMuted,
                          size: 18,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        quantity.toString(),
                        style: TextStyle(
                          fontFamily: 'GB',
                          fontSize: 16,
                          color: CustomColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          quantity++;
                        });
                        widget.onQuantityChanged(quantity);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.add,
                          color: CustomColors.primary,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Add to Favorites
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added to favorites!',
                        style: TextStyle(
                          fontFamily: 'GM',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: CustomColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CustomColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    color: CustomColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final BasketItem basketItem;
  const CardItem(this.basketItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      decoration: BoxDecoration(
        color: CustomColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CustomColors.surfaceColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    height: 104,
                    width: 75,
                    child: Center(
                      child: CachedImage(
                        imageUrl: basketItem.thumbnail,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          basketItem.name,
                          style: TextStyle(fontFamily: 'SB', fontSize: 16),
                        ),
                        SizedBox(height: 6),
                        const Text(
                          'Warranty',
                          style: TextStyle(fontFamily: 'SM', fontSize: 12),
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              basketItem.realPrice.toString(),
                              style: TextStyle(fontFamily: 'SM', fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            const Text(
                              '\$',
                              style: TextStyle(fontFamily: 'SM', fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    15,
                                  ),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 6),
                                child: Text(
                                  '%4',
                                  style: TextStyle(
                                      fontFamily: 'SB',
                                      fontSize: 12,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          children: [
                            OptionCheap(
                              'Blue',
                              color: '4287f5',
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: CustomColors.red, width: 1),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            fontFamily: 'SM',
                                            fontSize: 12,
                                            color: CustomColors.red),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Image.asset(
                                      'assets/images/icon_trash.png',
                                      color: CustomColors.red,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DottedLine(
              lineThickness: 3.0,
              dashLength: 8.0,
              dashColor: CustomColors.grey.withValues(alpha: 0.5),
              dashGapLength: 3.0,
              dashGapColor: Colors.transparent,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  basketItem.price.toString(),
                  style: TextStyle(fontFamily: 'SB', fontSize: 16),
                ),
                SizedBox(width: 5),
                Text(
                  '\$',
                  style: TextStyle(fontFamily: 'SB', fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OptionCheap extends StatelessWidget {
  final String? color;
  final String title;
  const OptionCheap(
    this.title, {
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.textMuted, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: CustomColors.surfaceColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(fontFamily: 'SM', fontSize: 12),
              ),
            ),
            if (color != null && color!.isNotEmpty) ...{
              Container(
                height: 12,
                width: 12,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: color.toColor()),
              )
            },
          ],
        ),
      ),
    );
  }
}
