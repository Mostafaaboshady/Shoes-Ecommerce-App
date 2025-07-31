import 'package:equatable/equatable.dart';
import '../../../product_details/data/models/product_model.dart';


class FavoritesState extends Equatable {
  final List<ProductModel> favoriteProducts;

  const FavoritesState({this.favoriteProducts = const []});

  FavoritesState copyWith({List<ProductModel>? favoriteProducts}) {
    return FavoritesState(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
    );
  }

  @override
  List<Object> get props => [favoriteProducts];
}
