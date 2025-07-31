import 'package:final_project/core/widgets/custom_appbar.dart';
import 'package:final_project/core/widgets/custom_button.dart';
import 'package:final_project/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../checkout/presentation/cubit/checkout_cubit.dart';
import '../../../../checkout/presentation/pages/checkout_page.dart';
import '../../models/cart_item_model.dart';
import '../cubit/cart_cubit.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Future<void> _showRemoveItemDialog(
      BuildContext context, CartItem item) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const CustomText(
              text: 'Remove Item', fontWeight: FontWeight.bold),
          content: const CustomText(
              text: 'Are you sure you want to remove this item from your cart?'),
          actions: <Widget>[
            TextButton(
              child: const CustomText(text: 'Cancel', color: Colors.grey),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const CustomText(text: 'Remove', color: Colors.red),
              onPressed: () {
                context.read<CartCubit>().removeFromCart(item);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(
        titleText: 'My Cart',
        leftIcon: Icons.arrow_back_ios_new,
        onLeftIconPressed: () => Navigator.of(context).pop(),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return const Center(
              child: CustomText(
                text: 'Your cart is empty!',
                fontSize: 18,
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = state.cartItems[index];
                    return _buildCartItemCard(context, item, theme);
                  },
                ),
              ),
              _buildCheckoutSection(context, state, theme),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItemCard(
      BuildContext context, CartItem item, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.product.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: item.product.name,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                const SizedBox(height: 4),
                CustomText(
                  text: '\$${item.product.price.toStringAsFixed(2)}',
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildQuantityButton(
                      context: context,
                      icon: Icons.remove,
                      onTap: () {
                        context.read<CartCubit>().decrementQuantity(item);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: CustomText(
                        text: item.quantity.toString(),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    _buildQuantityButton(
                      context: context,
                      icon: Icons.add,
                      onTap: () {
                        context.read<CartCubit>().incrementQuantity(item);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: 'Size: ${item.selectedSize}',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _showRemoveItemDialog(context, item),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
      {required BuildContext context,
        required IconData icon,
        required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 16, color: theme.iconTheme.color),
      ),
    );
  }

  Widget _buildCheckoutSection(
      BuildContext context, CartState state, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: 'Total Cost',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                text: '\$${state.totalCost.toStringAsFixed(2)}',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  // Provide the CheckoutCubit to the CheckoutPage
                  builder: (_) => BlocProvider(
                    create: (context) => CheckoutCubit(),
                    child: const CheckoutPage(),
                  ),
                ),
              );
            },
            child: const CustomText(
              text: 'Checkout',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}