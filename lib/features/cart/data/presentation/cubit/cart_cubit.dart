import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/cart_item_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(CartItem newItem) {
    final List<CartItem> updatedCart = List.from(state.cartItems);
    final existingItemIndex =
    updatedCart.indexWhere((item) => item.id == newItem.id);

    if (existingItemIndex != -1) {
      // If item with the same ID and size exists, just increase quantity
      updatedCart[existingItemIndex].quantity++;
    } else {
      updatedCart.add(newItem);
    }
    _emitNewState(updatedCart);
  }

  void removeFromCart(CartItem itemToRemove) {
    final List<CartItem> updatedCart = List.from(state.cartItems);
    updatedCart.removeWhere((item) => item.id == itemToRemove.id);
    _emitNewState(updatedCart);
  }

  void incrementQuantity(CartItem itemToUpdate) {
    final List<CartItem> updatedCart = List.from(state.cartItems);
    final itemIndex =
    updatedCart.indexWhere((item) => item.id == itemToUpdate.id);
    if (itemIndex != -1) {
      updatedCart[itemIndex].quantity++;
      _emitNewState(updatedCart);
    }
  }

  void decrementQuantity(CartItem itemToUpdate) {
    final List<CartItem> updatedCart = List.from(state.cartItems);
    final itemIndex =
    updatedCart.indexWhere((item) => item.id == itemToUpdate.id);
    if (itemIndex != -1 && updatedCart[itemIndex].quantity > 1) {
      updatedCart[itemIndex].quantity--;
      _emitNewState(updatedCart);
    }
  }

  void _emitNewState(List<CartItem> cartItems) {
    double total = 0;
    for (var item in cartItems) {
      total += item.product.price * item.quantity;
    }
    emit(state.copyWith(cartItems: cartItems, totalCost: total));
  }
  void clearCart() {
    _emitNewState([]);
  }


}
