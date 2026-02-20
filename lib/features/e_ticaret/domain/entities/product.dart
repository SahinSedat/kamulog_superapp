import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final int stock;
  final String? description;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.stock = 0,
    this.description,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    imageUrl,
    stock,
    description,
    createdAt,
  ];
}
