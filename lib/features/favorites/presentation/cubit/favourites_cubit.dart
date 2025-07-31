import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../product_details/data/models/product_model.dart';
import 'favourites_state.dart';


class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesState());

  void toggleFavorite(ProductModel product) {
    final List<ProductModel> updatedFavorites = List.from(state.favoriteProducts);
    if (updatedFavorites.any((p) => p.id == product.id)) {
      updatedFavorites.removeWhere((p) => p.id == product.id);
    } else {
      updatedFavorites.add(product);
    }
    emit(state.copyWith(favoriteProducts: updatedFavorites));
  }

  bool isFavorite(ProductModel product) {
    return state.favoriteProducts.any((p) => p.id == product.id);
  }
}
