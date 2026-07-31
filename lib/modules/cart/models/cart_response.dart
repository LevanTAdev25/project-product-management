import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/product/models/product_response.dart';

//
class CartResponse extends ProductResponse {
  final int quantity;
  CartResponse({
    required super.id,
    required super.name,
    required super.code,
    required super.price,
    required super.stock,
    required super.category,
    required super.description,
    required super.image,
    required this.quantity,
  });
  factory CartResponse.mapToCartResponse(CartRequest cartRequest) {
    return CartResponse(
      id: cartRequest.id,
      name: cartRequest.name,
      code: cartRequest.code,
      price: cartRequest.price,
      stock: cartRequest.stock,
      category: cartRequest.category,
      description: cartRequest.description,
      image: cartRequest.image,
      quantity: cartRequest.quantity,
    );
  }
}
