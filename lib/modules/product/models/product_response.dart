import 'package:prjgetxmvc/modules/product/models/category.dart';

//
class ProductResponse {
  final int id;
  final String name;
  final String code;
  final double price;
  final int stock;
  final Category category;
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
  static ProductResponse fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      json['id'],
      json['name'],
      json['code'],
      (json['price'] as num).toDouble(),
      json['stock'],
      Category.fromJson(json['category']),
      json['description'],
      json['image'],
    );
  }
}
