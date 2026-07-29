import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/product/models/product_response.dart';

//
class CartResponse extends ProductResponse {
  final int quantity;
  CartResponse(
    super.id,
    super.name,
    super.code,
    super.price,
    super.stock,
    super.category,
    super.description,
    super.image,
    this.quantity,
  );
  static CartResponse mapToCartResponse(CartRequest cartRequest) {
    return CartResponse(
      cartRequest.id,
      cartRequest.name,
      cartRequest.code,
      cartRequest.price,
      cartRequest.stock,
      cartRequest.category,
      cartRequest.description,
      cartRequest.image,
      cartRequest.quantity,
    );
  }
}
