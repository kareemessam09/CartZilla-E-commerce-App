import 'dart:ui';

import 'package:ecommerce/bloc/product/product_bloc.dart';
import 'package:ecommerce/bloc/product/product_event.dart';
import 'package:ecommerce/bloc/product/product_state.dart';
import 'package:ecommerce/constants/colors.dart';
import 'package:ecommerce/data/model/basket_item.dart';
import 'package:ecommerce/data/model/product_image_model.dart';
import 'package:ecommerce/data/model/product_model.dart';
import 'package:ecommerce/data/model/product_property_model.dart';
import 'package:ecommerce/data/model/product_variant.dart';

import 'package:ecommerce/data/model/variant_type_model.dart';

import 'package:ecommerce/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  ProductDetailScreen(this.product, {super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    BlocProvider.of<ProductBloc>(context).add(
        ProductInitializedEvent(widget.product.id, widget.product.categoryId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundPrimary,
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Stack(
            children: [
              // Main scrollable content
              CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 60,
                    floating: true,
                    pinned: true,
                    backgroundColor:
                        CustomColors.backgroundPrimary.withValues(alpha: 0.9),
                    elevation: 0,
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CustomColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: CustomColors.textPrimary,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    actions: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: CustomColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: CustomColors.textPrimary,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),

                  if (state is ProductDetailLoadingState) ...{
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                color: CustomColors.primary,
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Loading product details...',
                              style: TextStyle(
                                fontFamily: 'GM',
                                fontSize: 16,
                                color: CustomColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  } else ...{
                    // Product Title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: TextStyle(
                                fontFamily: 'GB',
                                fontSize: 28,
                                color: CustomColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (state is ProductDetailResponseState) ...{
                              state.productCategory.fold(
                                (l) => const SizedBox.shrink(),
                                (productCategory) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: CustomColors.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    productCategory.title!,
                                    style: TextStyle(
                                      fontFamily: 'GM',
                                      fontSize: 14,
                                      color: CustomColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            },
                          ],
                        ),
                      ),
                    ),

                    // Product Gallery
                    if (state is ProductDetailResponseState) ...{
                      state.productImages.fold((l) {
                        return SliverToBoxAdapter(
                          child: ModernGalleryWidget(
                            widget.product.thumbnail,
                            [],
                          ),
                        );
                      }, (productImageList) {
                        return SliverToBoxAdapter(
                          child: ModernGalleryWidget(
                            widget.product.thumbnail,
                            productImageList,
                          ),
                        );
                      })
                    },

                    // Price Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            Text(
                              '\$${widget.product.realPrice}',
                              style: TextStyle(
                                fontFamily: 'GB',
                                fontSize: 32,
                                color: CustomColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (widget.product.discountPrice > 0) ...{
                              Text(
                                '\$${widget.product.price}',
                                style: TextStyle(
                                  fontFamily: 'GM',
                                  fontSize: 18,
                                  color: CustomColors.textMuted,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: CustomColors.error,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${widget.product.percent!.round()}% OFF',
                                  style: const TextStyle(
                                    fontFamily: 'GB',
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            },
                          ],
                        ),
                      ),
                    ),

                    // Rating Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.6',
                              style: TextStyle(
                                fontFamily: 'GB',
                                fontSize: 16,
                                color: CustomColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(256 reviews)',
                              style: TextStyle(
                                fontFamily: 'GM',
                                fontSize: 14,
                                color: CustomColors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color:
                                    CustomColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    color: CustomColors.success,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'In Stock',
                                    style: TextStyle(
                                      fontFamily: 'GM',
                                      fontSize: 12,
                                      color: CustomColors.success,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Variants Section
                    if (state is ProductDetailResponseState) ...{
                      state.productVariant.fold((l) {
                        return const SliverToBoxAdapter(
                            child: SizedBox.shrink());
                      }, (productVariantList) {
                        return ModernVariantSection(productVariantList);
                      })
                    },

                    // Product Description
                    SliverToBoxAdapter(
                      child:
                          ModernProductDescription(widget.product.description),
                    ),

                    // Technical Specifications
                    if (state is ProductDetailResponseState) ...{
                      state.productProperties.fold((l) {
                        return const SliverToBoxAdapter(
                            child: SizedBox.shrink());
                      }, (propertyList) {
                        return ModernProductProperties(propertyList);
                      })
                    },

                    // Bottom spacing for floating action button
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  }
                ],
              ),

              // Floating Add to Cart Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: CustomColors.backgroundPrimary,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: ModernAddToCartButton(widget.product),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Modern Gallery Widget with contemporary design
class ModernGalleryWidget extends StatefulWidget {
  final String? defaultProductThumbnail;
  final List<ProductImageModel> productImageList;

  const ModernGalleryWidget(
    this.defaultProductThumbnail,
    this.productImageList, {
    super.key,
  });

  @override
  State<ModernGalleryWidget> createState() => _ModernGalleryWidgetState();
}

class _ModernGalleryWidgetState extends State<ModernGalleryWidget> {
  int selectedItem = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Main Image Display
          Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.cardBackground,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    selectedItem = index;
                  });
                },
                itemCount: widget.productImageList.isEmpty
                    ? 1
                    : widget.productImageList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: CachedImage(
                      imageUrl: widget.productImageList.isEmpty
                          ? widget.defaultProductThumbnail!
                          : widget.productImageList[index].imageUrl!,
                      radius: 16,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Thumbnail Row
          if (widget.productImageList.isNotEmpty) ...{
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.productImageList.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedItem == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedItem = index;
                      });
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(
                                color: CustomColors.primary,
                                width: 2,
                              )
                            : Border.all(
                                color: CustomColors.cardBackground,
                                width: 1,
                              ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: CustomColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedImage(
                          imageUrl: widget.productImageList[index].imageUrl!,
                          radius: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          },

          // Page Indicators
          if (widget.productImageList.length > 1) ...{
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.productImageList.length,
                (index) => Container(
                  width: selectedItem == index ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: selectedItem == index
                        ? CustomColors.primary
                        : CustomColors.textMuted.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          },
        ],
      ),
    );
  }
}

// Modern Variant Section
class ModernVariantSection extends StatelessWidget {
  final List<ProductVariant> productVariantList;

  const ModernVariantSection(this.productVariantList, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CustomColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Options',
              style: TextStyle(
                fontFamily: 'GB',
                fontSize: 20,
                color: CustomColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...productVariantList
                .map((variant) => ModernVariantItem(variant))
                .toList(),
          ],
        ),
      ),
    );
  }
}

// Modern Variant Item
class ModernVariantItem extends StatefulWidget {
  final ProductVariant productVariant;

  const ModernVariantItem(this.productVariant, {super.key});

  @override
  State<ModernVariantItem> createState() => _ModernVariantItemState();
}

class _ModernVariantItemState extends State<ModernVariantItem> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.productVariant.variantList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.productVariant.variantType.title!,
          style: TextStyle(
            fontFamily: 'GB',
            fontSize: 16,
            color: CustomColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (widget.productVariant.variantType.type == VariantTypeEnum.COLOR)
          _buildColorVariants()
        else
          _buildTextVariants(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildColorVariants() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: widget.productVariant.variantList.asMap().entries.map((entry) {
        final index = entry.key;
        final variant = entry.value;
        final isSelected = selectedIndex == index;

        String categoryColor = 'ff${variant.value}';
        int hexColor = int.parse(categoryColor, radix: 16);

        return GestureDetector(
          onTap: () => setState(() => selectedIndex = index),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(hexColor),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: CustomColors.primary, width: 3)
                  : Border.all(
                      color: CustomColors.textMuted.withOpacity(0.3), width: 1),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: CustomColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextVariants() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: widget.productVariant.variantList.asMap().entries.map((entry) {
        final index = entry.key;
        final variant = entry.value;
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => setState(() => selectedIndex = index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? CustomColors.primary
                  : CustomColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? CustomColors.primary
                    : CustomColors.textMuted.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: CustomColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              variant.value!,
              style: TextStyle(
                fontFamily: 'GM',
                fontSize: 14,
                color: isSelected ? Colors.white : CustomColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Modern Product Description
class ModernProductDescription extends StatefulWidget {
  final String productDescription;

  const ModernProductDescription(this.productDescription, {super.key});

  @override
  State<ModernProductDescription> createState() =>
      _ModernProductDescriptionState();
}

class _ModernProductDescriptionState extends State<ModernProductDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Description',
                style: TextStyle(
                  fontFamily: 'GB',
                  fontSize: 20,
                  color: CustomColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CustomColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: CustomColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          if (isExpanded) ...{
            const SizedBox(height: 16),
            Text(
              widget.productDescription,
              style: TextStyle(
                fontFamily: 'GM',
                fontSize: 16,
                color: CustomColors.textSecondary,
                height: 1.6,
              ),
            ),
          },
        ],
      ),
    );
  }
}

// Modern Product Properties
class ModernProductProperties extends StatefulWidget {
  final List<Property> productPropertyList;

  const ModernProductProperties(this.productPropertyList, {super.key});

  @override
  State<ModernProductProperties> createState() =>
      _ModernProductPropertiesState();
}

class _ModernProductPropertiesState extends State<ModernProductProperties> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CustomColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Specifications',
                  style: TextStyle(
                    fontFamily: 'GB',
                    fontSize: 20,
                    color: CustomColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => isExpanded = !isExpanded),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: CustomColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: CustomColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            if (isExpanded) ...{
              const SizedBox(height: 16),
              ...widget.productPropertyList
                  .map(
                    (property) => Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: CustomColors.textMuted.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            property.title!,
                            style: TextStyle(
                              fontFamily: 'GM',
                              fontSize: 16,
                              color: CustomColors.textSecondary,
                            ),
                          ),
                          Text(
                            property.value!,
                            style: TextStyle(
                              fontFamily: 'GB',
                              fontSize: 16,
                              color: CustomColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            },
          ],
        ),
      ),
    );
  }
}

// Modern Add to Cart Button
class ModernAddToCartButton extends StatefulWidget {
  final ProductModel product;

  const ModernAddToCartButton(this.product, {super.key});

  @override
  State<ModernAddToCartButton> createState() => _ModernAddToCartButtonState();
}

class _ModernAddToCartButtonState extends State<ModernAddToCartButton> {
  int quantity = 1;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _addToCart() {
    var item = BasketItem(
      widget.product.id,
      widget.product.collectionId,
      widget.product.thumbnail,
      widget.product.discountPrice,
      widget.product.price,
      widget.product.name,
      widget.product.categoryId,
    );

    // Use the correct box name that matches CardScreen
    var boxFuture = Hive.openBox<BasketItem>('basketItemBox');
    boxFuture.then((box) {
      // Add multiple items based on quantity
      for (int i = 0; i < quantity; i++) {
        box.add(item);
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            quantity == 1 ? 'Added to cart!' : 'Added $quantity items to cart!',
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Quantity Selector
        Container(
          decoration: BoxDecoration(
            color: CustomColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: CustomColors.textMuted.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Decrease Button
              GestureDetector(
                onTap: _decrementQuantity,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.remove,
                    color: quantity > 1
                        ? CustomColors.textPrimary
                        : CustomColors.textMuted,
                    size: 20,
                  ),
                ),
              ),

              // Quantity Display
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

              // Increase Button
              GestureDetector(
                onTap: _incrementQuantity,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.add,
                    color: CustomColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Add to Cart Button
        Expanded(
          child: GestureDetector(
            onTap: _addToCart,
            child: Container(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    quantity == 1 ? 'Add to Cart' : 'Add $quantity to Cart',
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
        ),
      ],
    );
  }
}
