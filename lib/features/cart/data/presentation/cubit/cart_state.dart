part of 'cart_cubit.dart';

class CartState extends Equatable {
  final List<CartItem> cartItems;
  final double totalCost;

  const CartState({
    this.cartItems = const [],
    this.totalCost = 0.0,
  });

  CartState copyWith({
    List<CartItem>? cartItems,
    double? totalCost,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      totalCost: totalCost ?? this.totalCost,
    );
  }

  @override
  List<Object> get props => [cartItems, totalCost];
}
