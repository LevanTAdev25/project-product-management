import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/routes/page_app.dart';
import 'package:prjgetxmvc/cores/services/auth_service.dart';

//
class BaseUnauthorized {
  static bool _isHandling = false;
  static Future<void> handleUnauthorized() async {
    if (_isHandling) return;
    _isHandling = true;
    try {
      final authService = Get.find<AuthService>();
      // final cartService = Get.find<CartService>();

      await authService.clearToken();
      // await cartService.clearCart();

      Get.snackbar(
        "Phiên đăng nhập hết hạn",
        "Vui lòng đăng nhập lại",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orangeAccent.withOpacity(0.9),
        colorText: Colors.white,
      );

      Get.offAllNamed(AppPage.LOGIN);
    } finally {
      _isHandling = false;
    }
  }
}
