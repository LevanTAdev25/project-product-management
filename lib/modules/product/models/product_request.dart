import 'package:prjgetxmvc/modules/category/models/category_request.dart';

//
class ProductRequest {
  int id;
  String name;
  String code;
  double price;
  int stock;
  CategoryRequest category;
  String description;
  String image;
  ProductRequest(
    this.id,
    this.name,
    this.code,
    this.price,
    this.stock,
    this.category,
    this.description,
    this.image,
  );
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'price': price,
      'stock': stock,
      'category_id': category.id,
      'description': description,
      'image': image,
    };
  }
}
