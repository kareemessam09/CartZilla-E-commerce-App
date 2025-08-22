import 'package:ecommerce/bloc/category/category_bloc.dart';
import 'package:ecommerce/bloc/category/category_event.dart';
import 'package:ecommerce/bloc/category/category_state.dart';
import 'package:ecommerce/constants/colors.dart';
import 'package:ecommerce/data/model/category_model.dart';
import 'package:ecommerce/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<CategoryModel>? list;

  @override
  void initState() {
    BlocProvider.of<CategoryBloc>(context).add(CategoryRequestEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 24),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: CustomColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: CustomColors.surfaceColor,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.apps_rounded,
                          color: CustomColors.primary,
                          size: 24,
                        ),
                        const Expanded(
                          child: Text(
                            'Categories',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'GB',
                              fontSize: 18,
                              color: CustomColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24), // Balance the icon
                      ],
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
              if (state is CategoryLoadingState) {
                return SliverToBoxAdapter(
                    child: CircularProgressIndicator(color: CustomColors.blue));
              } else if (state is CategoryResponseState) {
                return state.response.fold(
                  (l) {
                    return SliverToBoxAdapter(child: Center(child: Text(l)));
                  },
                  (r) {
                    return _categoryList(list: r);
                  },
                );
              }
              return SliverToBoxAdapter(child: Center(child: Text('Error')));
            }),
          ],
        ),
      ),
    );
  }
}

class _categoryList extends StatelessWidget {
  final List<CategoryModel>? list;

  const _categoryList({
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
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
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedImage(
                  imageUrl: list?[index].thumbnail ?? 'test',
                ),
              ),
            );
          },
          childCount: list?.length ?? 0,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
      ),
    );
  }
}
