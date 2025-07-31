import 'package:final_project/features/product_details/data/models/product_model.dart';

class CartItem {
  final ProductModel product;
  final String selectedSize;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    this.quantity = 1,
  });

  // A unique ID for each cart item based on product ID and size
  String get id => '${product.id}_$selectedSize';
}
