import 'package:ecommerce/bloc/home/home_bloc.dart';
import 'package:ecommerce/bloc/home/home_event.dart';
import 'package:ecommerce/bloc/home/home_state.dart';
import 'package:ecommerce/constants/colors.dart';
import 'package:ecommerce/data/model/banner_model.dart';
import 'package:ecommerce/data/model/category_model.dart';
import 'package:ecommerce/data/model/product_model.dart';
import 'package:ecommerce/widgets/banner_slider.dart';
import 'package:ecommerce/widgets/category_icon_item_list.dart';
import 'package:ecommerce/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(HomeGetInitializeEvent());
    // BlocProvider.of<HomeBloc>(context).add(HomeGetBestSellerEvent());
    // BlocProvider.of<HomeBloc>(context).add(Home());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundPrimary,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return CustomScrollView(slivers: [
              if (state is HomeLoadingState) ...{
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        color: CustomColors.primary,
                      ),
                    ),
                  ),
                )
              } else ...{
                _getSearchBox(),
                if (state is HomeRequestSuccessState) ...[
                  state.bannerList.fold(
                    (exceptionMessages) {
                      return SliverToBoxAdapter(
                        child: Text(exceptionMessages),
                      );
                    },
                    (listBanner) {
                      return _getBanners(listBanner);
                    },
                  )
                ],
                _getCategoryListTitle(),
                if (state is HomeRequestSuccessState) ...[
                  state.categoryList.fold(
                    (exceptionMessages) {
                      return SliverToBoxAdapter(
                        child: Text(exceptionMessages),
                      );
                    },
                    (categoryList) {
                      return _getCategoryList(categoryList);
                    },
                  )
                ],
                _getBestSellerTitle(),
                if (state is HomeRequestSuccessState) ...[
                  state.bestSellerProductList.fold(
                    (exceptionMessages) {
                      return SliverToBoxAdapter(
                        child: Text(exceptionMessages),
                      );
                    },
                    (productList) {
                      return _getBestSellerProducts(productList);
                    },
                  )
                ],
                _getMostViewedTitle(),
                if (state is HomeRequestSuccessState) ...[
                  state.hottestProductList.fold(
                    (exceptionMessages) {
                      return SliverToBoxAdapter(
                        child: Text(exceptionMessages),
                      );
                    },
                    (productList) {
                      return _getMostViewedProduct(productList);
                    },
                  )
                ],
              },
            ]);
          },
        ),
      ),
    );
  }
}

class _getMostViewedProduct extends StatelessWidget {
  final List<ProductModel> productList;
  const _getMostViewedProduct(
    this.productList,
  );

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: SizedBox(
          height: 270, // Increased from 200 to accommodate ProductItem height
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ProductItem(productList[index]),
                );
              })),
        ),
      ),
    );
  }
}

class _getMostViewedTitle extends StatelessWidget {
  const _getMostViewedTitle();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 32),
        child: Row(
          children: [
            const Text(
              'Most Viewed',
              style: TextStyle(
                fontFamily: 'GB',
                fontSize: 18,
                color: CustomColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            GestureDetector(
              child: Row(
                children: [
                  const Text(
                    'View All',
                    style: TextStyle(
                      fontFamily: 'GM',
                      fontSize: 14,
                      color: CustomColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColors.primary,
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _getBestSellerProducts extends StatelessWidget {
  final List<ProductModel> productList;
  const _getBestSellerProducts(
    this.productList,
  );

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: SizedBox(
          height: 270, // Increased from 200 to accommodate ProductItem height
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ProductItem(productList[index]),
                );
              })),
        ),
      ),
    );
  }
}

class _getBestSellerTitle extends StatelessWidget {
  const _getBestSellerTitle();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 32),
        child: Row(
          children: [
            const Text(
              'Best Sellers',
              style: TextStyle(
                fontFamily: 'GB',
                fontSize: 18,
                color: CustomColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            GestureDetector(
              child: Row(
                children: [
                  const Text(
                    'View All',
                    style: TextStyle(
                      fontFamily: 'GM',
                      fontSize: 14,
                      color: CustomColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColors.primary,
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _getCategoryList extends StatelessWidget {
  final List<CategoryModel> categoryList;
  const _getCategoryList(
    this.categoryList,
  );

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: 20),
              child: CategoryIconItemChip(categoryList[index]),
            );
          },
        ),
      ),
    ));
  }
}

class _getCategoryListTitle extends StatelessWidget {
  const _getCategoryListTitle();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 32),
        child: Row(
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontFamily: 'GB',
                fontSize: 18,
                color: CustomColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            GestureDetector(
              child: Row(
                children: [
                  const Text(
                    'View All',
                    style: TextStyle(
                      fontFamily: 'GM',
                      fontSize: 14,
                      color: CustomColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColors.primary,
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _getBanners extends StatelessWidget {
  final List<BannerModel> banners;
  const _getBanners(
    this.banners,
  );

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BannerSlider(
        bannerList: banners,
      ),
    );
  }
}

class _getSearchBox extends StatelessWidget {
  const _getSearchBox();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: CustomColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: CustomColors.surfaceColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: CustomColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Search Products',
                    style: TextStyle(
                      fontFamily: 'GM',
                      fontSize: 16,
                      color: CustomColors.textSecondary,
                    ),
                  ),
                ),
                Icon(
                  Icons.tune,
                  color: CustomColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
