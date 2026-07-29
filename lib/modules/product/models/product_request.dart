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
  static Map<String, dynamic> toJson(ProductRequest productRequest) {
    return {
      'name': productRequest.name,
      'code': productRequest.code,
      'price': productRequest.price,
      'stock': productRequest.stock,
      'category_id': productRequest.category.id,
      'description': productRequest.description,
      'image': productRequest.image,
    };
  }
}
