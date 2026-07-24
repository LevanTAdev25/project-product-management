import 'package:prjgetxmvc/modules/category/models/category_response.dart';

//
class ProductResponse {
  final int id;
  final String name;
  final String code;
  final double price;
  final int stock;
  final CategoryResponse category;
  final String description;
  final String image;
  ProductResponse(
    this.id,
    this.name,
    this.code,
    this.price,
    this.stock,
    this.category,
    this.description,
    this.image,
  );
  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    try {
      return ProductResponse(
        json['id'] as int,
        json['name'] as String,
        json['code'] as String,
        (json['price'] as num).toDouble(),
        json['stock'] as int,
        CategoryResponse.fromJson(json['category'] as Map<String, dynamic>),
        json['description'] as String? ?? "",
        json['image'] as String? ?? "",
      );
    } catch (e) {
      throw const FormatException('ProductResponse parse failed');
    }
  }
}
