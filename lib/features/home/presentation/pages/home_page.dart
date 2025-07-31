import 'package:final_project/core/widgets/custom_card.dart';
import 'package:final_project/core/widgets/custom_text.dart';
import 'package:final_project/core/widgets/custom_text_field.dart';
import 'package:final_project/features/product_details/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/brand_list_item.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_navigation_bar.dart';
import '../../../../core/widgets/custom_side_menu.dart';
import '../../../cart/data/presentation/pages/cart_page.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';
import '../../data/models/brand_model.dart';
import '../cubit/home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _navBarSelectedIndex = 1;

  void _onNavBarItemTapped(int index) {
    if (index == _navBarSelectedIndex) return;

    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FavoritesPage()),
        );
        break;
      case 1:
        setState(() {
          _navBarSelectedIndex = index;
        });
        break;
      case 2:
        Navigator.pushNamed(context, RouteNames.accountPage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const CustomSideMenu(),
        appBar: CustomAppbar(
          rightIcon: IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
          leftIcon: Icons.apps,
          titleText: 'Mondolibug, Sylhet',

          showLocation: true,
          onLeftIconPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeError) {
              return Center(child: Text(state.message));
            }
            if (state is HomeLoaded) {
              final popularProducts = state.filteredProducts;
              final displayedPopularProducts =
              popularProducts.sublist(0, min(4, popularProducts.length));
              final newArrivals = state.newArrivals;
              final randomProduct =
              newArrivals.isNotEmpty ? newArrivals.first : ProductModel.empty();

              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth > 600 ? 32.0 : 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          CustomTextField(
                            isSearchField: true,
                            hintText: 'Looking for shoes',
                            onChanged: (query) {
                              context.read<HomeCubit>().searchProducts(query);
                            },
                          ),
                          const SizedBox(height: 30),
                          if (state.searchQuery.isEmpty)
                            SizedBox(
                              height: 55,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: BrandModels.length,
                                itemBuilder: (context, index) {
                                  final brandModel = BrandModels[index];
                                  final isSelected =
                                      state.brandSelectedIndex == index;
                                  return GestureDetector(
                                    onTap: () {
                                      context
                                          .read<HomeCubit>()
                                          .selectBrand(index);
                                    },
                                    child: BrandListItem(
                                      brand: brandModel,
                                      isSelected: isSelected,
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: state.searchQuery.isEmpty
                                    ? 'Popular Shoes'
                                    : 'Search Results',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              if (state.searchQuery.isEmpty)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.brandProducts,
                                      arguments: {
                                        'brand': BrandModels[
                                        state.brandSelectedIndex]
                                            .name,
                                        'products': popularProducts,
                                      },
                                    );
                                  },
                                  child: CustomText(
                                    text: 'See all',
                                    fontSize: 18,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          if (popularProducts.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CustomText(text: "No shoes found."),
                              ),
                            )
                          else
                            SizedBox(
                              height: 220,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: displayedPopularProducts.length,
                                separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final product =
                                  displayedPopularProducts[index];
                                  return CustomCard(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.productDetails,
                                        arguments: product,
                                      );
                                    },
                                    model: product,
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 40),
                          if (state.searchQuery.isEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomText(
                                  text: 'New Arrivals',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.randomProducts,
                                      arguments: newArrivals,
                                    );
                                  },
                                  child: CustomText(
                                    text: 'See all',
                                    fontSize: 18,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            if (randomProduct != ProductModel.empty())
                              _buildNewArrivalsCard(randomProduct, constraints),
                          ],
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _navBarSelectedIndex,
          onItemTapped: _onNavBarItemTapped,
        ),
      ),
    );
  }

  Widget _buildNewArrivalsCard(
      ProductModel product, BoxConstraints constraints) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteNames.productDetails,
          arguments: product,
        );
      },
      child: Container(
        width: double.infinity,
        height: constraints.maxWidth > 800 ? 200 : 150,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Best Choice',
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 5),
                    CustomText(
                      text: product.name,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    CustomText(
                      text: '\$${product.price}',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported,
                      color: Colors.grey, size: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
