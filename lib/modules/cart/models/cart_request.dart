import 'package:hive_flutter/hive_flutter.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_response.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';
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
  CartRequest(
    this.id,
    this.name,
    this.code,
    this.price,
    this.stock,
    this.category,
    this.description,
    this.image,
    this.quantity,
  );
  CartRequest copyWith({int? quantity}) {
    return CartRequest(
      id,
      name,
      code,
      price,
      stock,
      category,
      description,
      image,
      quantity ?? this.quantity,
    );
  }

  static CartRequest mapToCartRequest(CartResponse cartResponse) {
    return CartRequest(
      cartResponse.id,
      cartResponse.name,
      cartResponse.code,
      cartResponse.price,
      cartResponse.stock,
      cartResponse.category,
      cartResponse.description,
      cartResponse.image,
      cartResponse.quantity,
    );
  }
}
