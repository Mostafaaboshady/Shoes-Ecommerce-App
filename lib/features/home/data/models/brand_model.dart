class BrandModel {
  final String name;
  final String logoAsset;

  BrandModel({required this.name, required this.logoAsset});
}

final List<BrandModel> BrandModels = [
  BrandModel(name: 'Nike', logoAsset: 'assets/logos/nike.png'),
  BrandModel(name: 'Puma', logoAsset: 'assets/logos/puma.png'),
  BrandModel(name: 'Under Armour', logoAsset: 'assets/logos/under-armour.png'),
  BrandModel(name: 'Adidas', logoAsset: 'assets/logos/adidas.png'),
  BrandModel(name: 'Converse', logoAsset: 'assets/logos/converse.png'),
];
