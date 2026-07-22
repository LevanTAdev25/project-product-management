import 'package:prjgetxmvc/cores/services/cart_service.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_response.dart';

class CartRepository {
  final CartService _cartService;
  CartRepository(this._cartService);
  Future<void> removeCart(int id) async {
    await _cartService.removeCart(id);
  }

  List<CartResponse> getCartList() {
    final cartRequestList = _cartService.getListCart();
    final List<CartResponse> cartResponseList = [];
    for (final cartRequest in cartRequestList) {
      cartResponseList.add(CartResponse.mapToCartResponse(cartRequest));
    }
    return cartResponseList;
  }

  Future<void> decreaseCart(CartRequest cart) async {
    await _cartService.decreaseCart(cart);
  }

  Future<void> increaseCart(CartRequest cart) async {
    await _cartService.increaseCart(cart);
  }
}
