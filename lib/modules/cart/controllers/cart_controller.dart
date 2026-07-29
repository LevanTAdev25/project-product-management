import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prjgetxmvc/cores/base/base_snack_bar.dart';
import 'package:prjgetxmvc/cores/exceptions/cart_exception.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_response.dart';
import 'package:prjgetxmvc/modules/cart/repositories/cart_repository.dart';
import 'package:prjgetxmvc/modules/product/controllers/product_controller.dart';

//
class CartController extends GetxController {
  final CartRepository _cartRepository;
  final cartList = <CartResponse>[].obs;
  final totalPrice = 0.0.obs;
  final isLoading = false.obs;
  final priceFormatter = NumberFormat("#,##0", "vi_VN");

  CartController(this._cartRepository);
  @override
  void onInit() {
    super.onInit();
    getCartList();
  }

  void _updateCartBadge() {
    if (Get.isRegistered<ProductController>()) {
      Get.find<ProductController>().countCartItem();
    }
  }

  void getCartList() {
    try {
      final cartListFromLocal = _cartRepository.getCartList();

      cartList.assignAll(cartListFromLocal);

      calculateTotalPrice();
      _updateCartBadge();
    } on CartException catch (e) {
      cartList.clear();
      totalPrice.value = 0;

      BaseSnackBar.showSnackBar(
        title: 'Lỗi giỏ hàng',
        content: e.message,
        color: Colors.red,
      );
    } catch (e, stackTrace) {
      cartList.clear();
      totalPrice.value = 0;

      debugPrint('Lỗi đọc giỏ hàng: $e');
      debugPrintStack(stackTrace: stackTrace);

      BaseSnackBar.showSnackBar(
        title: 'Lỗi',
        content: 'Không thể tải danh sách giỏ hàng',
        color: Colors.red,
      );
    }
  }

  void removeCart(int id) async {
    try {
      isLoading.value = true;

      await _cartRepository.removeCart(id);

      getCartList();

      BaseSnackBar.showSnackBar(
        title: "Thành công",
        content: "Sản phẩm đã được xóa thành công",
        color: Colors.green,
      );
    } on CartItemNotFoundException catch (e) {
      BaseSnackBar.showSnackBar(
        title: 'Không tìm thấy sản phẩm',
        content: e.message,
        color: Colors.red,
      );

      // Có thể dữ liệu UI đã cũ, nên tải lại danh sách.
      getCartList();
    } on CartException catch (e) {
      BaseSnackBar.showSnackBar(
        title: 'Lỗi giỏ hàng',
        content: e.message,
        color: Colors.red,
      );
    } catch (e, stackTrace) {
      debugPrint('Lỗi xóa sản phẩm: $e');
      debugPrintStack(stackTrace: stackTrace);

      BaseSnackBar.showSnackBar(
        title: 'Lỗi',
        content: 'Không thể xóa sản phẩm khỏi giỏ hàng',
        color: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void decreaseCart(int id) async {
    try {
      isLoading.value = true;

      await _cartRepository.decreaseCart(id);

      getCartList();
    } on CartItemNotFoundException catch (e) {
      BaseSnackBar.showSnackBar(
        title: 'Không tìm thấy sản phẩm',
        content: e.message,
        color: Colors.red,
      );

      getCartList();
    } on CartException catch (e) {
      BaseSnackBar.showSnackBar(
        title: 'Lỗi giỏ hàng',
        content: e.message,
        color: Colors.red,
      );
    } catch (e, stackTrace) {
      debugPrint('Lỗi giảm số lượng: $e');
      debugPrintStack(stackTrace: stackTrace);

      BaseSnackBar.showSnackBar(
        title: 'Lỗi',
        content: 'Không thể giảm số lượng sản phẩm',
        color: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void increaseCart(int id) async {
    try {
      isLoading.value = true;

      await _cartRepository.increaseCart(id);

      getCartList();
    } on CartOutOfStockException catch (e) {
      BaseSnackBar.showSnackBar(
        title: "Thông báo",
        content: e.toString().replaceAll("Exception: ", ""),
        color: Colors.red,
      );
    } on CartItemNotFoundException catch (e) {
      BaseSnackBar.showSnackBar(
        title: 'Không tìm thấy sản phẩm',
        content: e.message,
        color: Colors.red,
      );

      getCartList();
    } on CartException catch (e) {
      BaseSnackBar.showSnackBar(
        title: 'Lỗi giỏ hàng',
        content: e.message,
        color: Colors.red,
      );
    } catch (e, stackTrace) {
      debugPrint('Lỗi tăng số lượng: $e');
      debugPrintStack(stackTrace: stackTrace);

      BaseSnackBar.showSnackBar(
        title: 'Lỗi',
        content: 'Không thể tăng số lượng sản phẩm',
        color: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
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
