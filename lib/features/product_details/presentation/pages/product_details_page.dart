import 'package:final_project/core/widgets/custom_appbar.dart';
import 'package:final_project/core/widgets/custom_card.dart';
import 'package:final_project/core/widgets/custom_text.dart';
import 'package:final_project/core/widgets/gallery_container.dart';
import 'package:final_project/core/widgets/sizes_container.dart';
import 'package:final_project/features/cart/data/models/cart_item_model.dart';
import 'package:final_project/features/home/presentation/cubit/home_cubit.dart';
import 'package:final_project/features/product_details/data/models/sizes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../cart/data/presentation/cubit/cart_cubit.dart';
import '../../../cart/data/presentation/pages/cart_page.dart';
import '../../data/models/product_model.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.initialProduct});

  final ProductModel initialProduct;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _selectedSizeIndex = 0;
  final ScrollController _scrollController = ScrollController();

  late ProductModel selectedProduct;

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.initialProduct;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(
          rightIcon: IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
          leftIcon: Icons.arrow_back_ios_new,
          titleText: 'Men’s Shoes',
          onLeftIconPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 600;
            if (isWide) {
              return _buildWideLayout();
            } else {
              return _buildNarrowLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        _buildProductImage(),
        const SizedBox(height: 20),
        Expanded(child: _buildProductInfo()),
      ],
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildProductImage(),
            ),
          ),
        ),
        Expanded(flex: 1, child: _buildProductInfo()),
      ],
    );
  }

  Widget _buildProductImage() {
    final theme = Theme.of(context);
    return Container(
      height: 300,
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (theme.brightness == Brightness.light)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                selectedProduct.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: CustomText(text: 'Image Not Found'),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            child: Image.asset(
              'assets/icons/circle.png',
              width: 250,
              color: theme.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.1)
                  : null,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Best Seller',
                fontSize: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: selectedProduct.name,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              CustomText(
                text: '\$${selectedProduct.price}',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 15),
              CustomText(
                text: selectedProduct.description,
                fontSize: 16,
              ),
              const SizedBox(height: 20),
              _buildMoreFromBrandSection(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: 'Size',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  Row(
                    children: const [
                      CustomText(
                        text: 'EU',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(width: 10),
                      CustomText(text: 'US', fontSize: 18),
                      SizedBox(width: 10),
                      CustomText(text: 'UK', fontSize: 18),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: List.generate(SizesModel.sizes.length, (index) {
                  final size = SizesModel.sizes[index];
                  final isSelected = _selectedSizeIndex == index;
                  return SizesContainer(
                    sizesModel: size,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedSizeIndex = index;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(text: 'Price', fontSize: 16),
                      const SizedBox(height: 5),
                      CustomText(
                        text: '\$${selectedProduct.price}',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(width: 120),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        final cartItem = CartItem(
                          product: selectedProduct,
                          selectedSize:
                          SizesModel.sizes[_selectedSizeIndex].size,
                        );
                        context.read<CartCubit>().addToCart(cartItem);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const CustomText(
                        text: 'Add To Cart',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  Widget _buildMoreFromBrandSection() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          final sameBrandProducts = state.allProducts
              .where((p) => p.brand == selectedProduct.brand)
              .toList();

          if (sameBrandProducts.length <= 1) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'More from ${selectedProduct.brand}',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: sameBrandProducts.length,
                  itemBuilder: (context, index) {
                    final product = sameBrandProducts[index];
                    final isSelected = product.id == selectedProduct.id;
                    return GalleryContainer(
                      imageUrl: product.image,
                      isSelected: isSelected,
                      onTap: () {
                        if (isSelected) return;
                        setState(() {
                          selectedProduct = product;
                          _selectedSizeIndex = 0;
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        });
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                  const SizedBox(width: 15),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
