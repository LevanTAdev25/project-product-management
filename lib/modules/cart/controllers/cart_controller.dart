import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_response.dart';
import 'package:prjgetxmvc/modules/cart/repositories/cart_repository.dart';
import 'package:prjgetxmvc/modules/product/controllers/product_controller.dart';

class CartController extends GetxController {
  final CartRepository _cartRepository;
  final cartList = <CartResponse>[].obs;
  final totalPrice = 0.0.obs;
  final priceFormatter = NumberFormat("#,##0", "vi_VN");

  CartController(this._cartRepository);
  @override
  void onInit() {
    super.onInit();
    getCartList();
  }

  void getCartList() {
    final cartListFromLocal = _cartRepository.getCartList();
    if (cartListFromLocal.isNotEmpty) {
      cartList.assignAll(cartListFromLocal);
    } else {
      cartList.value = [];
    }
    final productController = Get.find<ProductController>();
    productController.countCartItem();
    calculateTotalPrice();
  }

  void removeCart(int id) async {
    await _cartRepository.removeCart(id);
    Get.snackbar(
      "Thành công",
      "Sản phẩm đã bị xóa khỏi giỏ hàng",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 10,
    );

    getCartList();
  }

  void decreaseCart(CartRequest cart) async {
    await _cartRepository.decreaseCart(cart);

    getCartList();
  }

  void increaseCart(CartRequest cart) async {
    await _cartRepository.increaseCart(cart);

    getCartList();
  }

  void calculateTotalPrice() {
    double currentTotalPrice = 0;
    if (cartList.isNotEmpty) {
      for (final i in cartList) {
        currentTotalPrice += i.price * i.quantity;
      }
      totalPrice.value = currentTotalPrice;
    }
  }
}
