import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

class ProductModel {
  final String id;
  final String name;
  final String brand;
  final String image;
  final double price;
  final String description;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.image,
    required this.price,
    required this.description,
    this.isFavorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'],
      brand: json['brand'],
      image: json['image'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'],
    );
  }

  factory ProductModel.empty() {
    return ProductModel(
      id: '',
      name: '',
      brand: '',
      image: '',
      price: 0.0,
      description: '',
      isFavorite: false,
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? brand,
    String? image,
    double? price,
    String? description,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      image: image ?? this.image,
      price: price ?? this.price,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
