import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';

//
class CartService extends GetxService {
  late Box<CartRequest> cartBox;
  Future<CartService> init() async {
    cartBox = await Hive.openBox<CartRequest>("list_cart");
    return this;
  }

  List<CartRequest> getListCart() {
    return cartBox.values.toList();
  }

  Future<void> addToListCart(CartRequest cartRequest) async {
    final current = cartBox.get(cartRequest.id);
    if (current == null) {
      await cartBox.put(cartRequest.id, cartRequest);
    }
  }

  Future<void> decreaseCart(CartRequest cartRequest) async {
    final current = cartBox.get(cartRequest.id);
    if (current != null) {
      if (current.quantity == 1) {
        await cartBox.delete(current.id);
      } else {
        await cartBox.put(
          current.id,
          current.copyWith(quantity: current.quantity - 1),
        );
      }
    }
  }

  Future<void> increaseCart(CartRequest cartRequest) async {
    final current = cartBox.get(cartRequest.id);
    if (current != null) {
      if (current.quantity < current.stock) {
        await cartBox.put(
          current.id,
          current.copyWith(quantity: current.quantity + 1),
        );
      }
    }
  }

  Future<void> removeCart(int id) async {
    await cartBox.delete(id);
  }

  Future<void> clearCart() async {
    await cartBox.clear();
  }
}
