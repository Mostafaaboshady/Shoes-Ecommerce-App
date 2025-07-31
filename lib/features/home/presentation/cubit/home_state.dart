part of 'home_cubit.dart';

@immutable
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<ProductModel> allProducts;
  final int brandSelectedIndex;
  final String searchQuery;

  const HomeLoaded({
    required this.allProducts,
    this.brandSelectedIndex = 0,
    this.searchQuery = '',
  });

  List<ProductModel> get filteredProducts {
    final brandName = BrandModels[brandSelectedIndex].name;
    final brandFiltered = allProducts
        .where((p) => p.brand.toLowerCase() == brandName.toLowerCase())
        .toList();

    if (searchQuery.isNotEmpty) {
      return brandFiltered
          .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return brandFiltered;
  }

  List<ProductModel> get newArrivals {
    if (searchQuery.isNotEmpty) {
      return allProducts
          .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    final Map<String, ProductModel> brandProductMap = {};
    for (var product in allProducts) {
      brandProductMap.putIfAbsent(product.brand.toLowerCase(), () => product);
    }
    return brandProductMap.values.toList()..shuffle();
  }

  HomeLoaded copyWith({
    List<ProductModel>? allProducts,
    int? brandSelectedIndex,
    String? searchQuery,
  }) {
    return HomeLoaded(
      allProducts: allProducts ?? this.allProducts,
      brandSelectedIndex: brandSelectedIndex ?? this.brandSelectedIndex,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [allProducts, brandSelectedIndex, searchQuery];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
