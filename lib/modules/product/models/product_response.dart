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
  ProductResponse({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
    required this.image,
  });
  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    try {
      return ProductResponse(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? "",
        code: json['code'] as String? ?? "",
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        stock: json['stock'] as int? ?? 0,
        category: CategoryResponse.fromJson(
          json['category'] as Map<String, dynamic>,
        ),
        description: json['description'] as String? ?? "",
        image: json['image'] as String? ?? "",
      );
    } on FormatException catch (e) {
      throw FormatException("ProductResponse parse failed: $e");
    }
  }
}
