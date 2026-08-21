import 'package:hive_flutter/hive_flutter.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_response.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';
import 'package:prjgetxmvc/modules/product/models/product_response.dart';
part 'cart_request.g.dart';

//
@HiveType(typeId: 2)
class CartRequest {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String code;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final int stock;
  @HiveField(5)
  final CategoryResponse category;
  @HiveField(6)
  final String description;
  @HiveField(7)
  final String image;
  @HiveField(8)
  final int quantity;
  CartRequest({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
    required this.image,
    required this.quantity,
  });
  CartRequest copyWith({int? quantity}) {
    return CartRequest(
      id: id,
      name: name,
      code: code,
      price: price,
      stock: stock,
      category: category,
      description: description,
      image: image,
      quantity: quantity ?? this.quantity,
    );
  }
}
