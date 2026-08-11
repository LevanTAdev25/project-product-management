import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:prjgetxmvc/cores/arguments/cart_argument.dart';
import 'package:prjgetxmvc/cores/base/base_snack_bar.dart';
import 'package:prjgetxmvc/cores/exceptions/cart_exception.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_response.dart';

//
class CartController extends GetxController {
  final Box<CartRequest> _cartBox;
  final cartList = <CartResponse>[].obs;
  final totalPrice = 0.0.obs;
  final isLoading = false.obs;
  final isError = false.obs;
  final errorMessage = RxnString();
  final priceFormatter = NumberFormat("#,##0", "vi_VN");
  final isEditMode = false.obs;
  final selectedProductIds = <int>{}.obs;
  CartController(this._cartBox);
  @override
  void onInit() {
    super.onInit();
    loadCartList();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void toggleEditMode() {
    isEditMode.toggle();
    if (!isEditMode.value) {
      selectedProductIds.clear();
    }
  }

  void toggleProductSelection(int id) {
    if (selectedProductIds.contains(id)) {
      selectedProductIds.remove(id);
    } else {
      selectedProductIds.add(id);
    }
  }

  void clearSelection() {
    selectedProductIds.clear();
  }

  void selectedAllProducts() {
    selectedProductIds.assignAll(cartList.map((value) => value.id).toList());
  }

  bool get isAllSelected {
    return cartList.isNotEmpty && selectedProductIds.length == cartList.length;
  }

  void toggleSelectAll() {
    if (isAllSelected) {
      clearSelection();
    } else {
      selectedAllProducts();
    }
  }

  Future<void> removeSelectedProducts() async {
    if (selectedProductIds.isEmpty) {
      throw CartItemSelectedException();
    }
    try {
      isLoading.value = true;
      final ids = selectedProductIds.toList();
      await _cartBox.deleteAll(ids);
      BaseSnackBar.showSnackBar(
        title: "Thành công",
        content: "Đã xóa sản phẩm ra khỏi giỏ hàng",
        color: Colors.green,
      );
      for (final id in ids) {
        cartList.removeWhere((e) => e.id == id);
      }
      calculateTotalPrice();
      selectedProductIds.clear();
      isEditMode.value = false;
    } catch (e) {
      BaseSnackBar.showSnackBar(
        title: "Thất bại",
        content: e.toString(),
        color: Colors.redAccent,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loadCartList() {
    isError.value = false;
    errorMessage.value = null;
    try {
      if (Get.arguments is! CartArgument) {
        throw Exception("Dữ liệu không hợp lệ");
      }
      final argument = Get.arguments as CartArgument;
      cartList.assignAll(argument.cartList);
      calculateTotalPrice();
    } on CartException catch (e) {
      cartList.clear();
      totalPrice.value = 0;

      isError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    } catch (e, stackTrace) {
      cartList.clear();
      totalPrice.value = 0;

      debugPrint('Lỗi đọc giỏ hàng: $e');
      debugPrintStack(stackTrace: stackTrace);

      isError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    }
  }

  Future<void> decreaseCart(int id) async {
    try {
      isLoading.value = true;

      final current = _cartBox.get(id);

      if (current == null) {
        throw const CartItemNotFoundException();
      }

      if (current.quantity <= 1) {
        await _cartBox.delete(id);
        cartList.removeWhere((e) => e.id == id);
        calculateTotalPrice();
        return;
      }

      await _cartBox.put(id, current.copyWith(quantity: current.quantity - 1));
      int index = cartList.indexWhere((e) => e.id == id);
      if (index != -1) {
        cartList[index] = CartResponse.mapToCartResponse(
          current.copyWith(quantity: current.quantity - 1),
        );
      }
      calculateTotalPrice();
    } on CartItemNotFoundException catch (e) {
      BaseSnackBar.showSnackBar(
        title: 'Không tìm thấy sản phẩm',
        content: e.message,
        color: Colors.red,
      );
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

  Future<void> increaseCart(int id) async {
    try {
      final current = _cartBox.get(id);

      if (current == null) {
        throw const CartItemNotFoundException();
      }

      if (current.stock <= 0 || current.quantity >= current.stock) {
        throw const CartOutOfStockException();
      }

      await _cartBox.put(id, current.copyWith(quantity: current.quantity + 1));

      int index = cartList.indexWhere((e) => e.id == id);
      if (index != -1) {
        cartList[index] = CartResponse.mapToCartResponse(
          current.copyWith(quantity: current.quantity + 1),
        );
      }
      calculateTotalPrice();
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
    }
    totalPrice.value = currentTotalPrice;
  }
}
