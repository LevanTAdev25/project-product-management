import 'package:prjgetxmvc/modules/category/models/category_request.dart';

//
class ProductRequest {
  int? page;
  int? limit;
  int? id;
  String? name;
  String? code;
  double? price;
  int? stock;
  CategoryRequest? category;
  String? description;
  String? image;
  ProductRequest.create({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
    required this.image,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'price': price,
      'stock': stock,
      'category_id': category!.id,
      'description': description,
      'image': image,
    };
  }

  ProductRequest.query({
    required this.page,
    required this.limit,
    required this.category,
  });
}
