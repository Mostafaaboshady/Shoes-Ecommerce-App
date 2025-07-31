import 'package:flutter/material.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../product_details/data/models/product_model.dart';

class RandomProductsPage extends StatelessWidget {
  final List<ProductModel> products;

  const RandomProductsPage({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leftIcon: Icons.arrow_back_ios_new,
        titleText: 'New Arrivals',
        onLeftIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: products.isEmpty
          ? const Center(
        child: CustomText(text: 'No new arrivals found.'),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return CustomCard(
              onTap: () {
                Navigator.pushNamed(context, RouteNames.productDetails,
                    arguments: product);
              },
              model: product,
            );
          },
        ),
      ),
    );
  }
}
