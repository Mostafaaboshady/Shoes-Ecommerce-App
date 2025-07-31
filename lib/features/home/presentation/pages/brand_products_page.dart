import 'package:flutter/material.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../product_details/data/models/product_model.dart';

class BrandProductsPage extends StatelessWidget {
  final String brand;
  final List<ProductModel> products;

  const BrandProductsPage({
    required this.brand,
    required this.products,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leftIcon: Icons.arrow_back_ios_new,
        titleText: '$brand Shoes',
        onLeftIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
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
