import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:prjgetxmvc/cores/base/base_snack_bar.dart';
import 'package:prjgetxmvc/cores/exceptions/cart_exception.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_response.dart';
import 'package:prjgetxmvc/modules/product/controllers/product_controller.dart';

//
class CartController extends GetxController {
  static const String _boxName = 'list_cart';
  late final Box<CartRequest> _cartBox;
  bool _isInitialized = false;
  final cartList = <CartResponse>[].obs;
  final totalPrice = 0.0.obs;
  final isLoading = false.obs;
  final priceFormatter = NumberFormat("#,##0", "vi_VN");
  final isEditMode = false.obs;
  final selectedProductIds = <int>{}.obs;
  Future<CartController> init() async {
    try {
      _cartBox = await Hive.openBox<CartRequest>(_boxName);
      _isInitialized = true;
      return this;
    } catch (e) {
      throw CartStorageException('Không thể mở dữ liệu giỏ hàng: $e');
    }
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw const CartStorageException('CartRepository chưa được khởi tạo');
    }
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
    _ensureInitialized();
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
      selectedProductIds.clear();
      isEditMode.value = false;
      loadCartList();
      Get.find<ProductController>().countCartItem();
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

  void _updateCartBadge() {
    if (Get.isRegistered<ProductController>()) {
      Get.find<ProductController>().countCartItem();
    }
  }

  List<CartRequest> getCartList() {
    return _cartBox.values.toList();
  }

  void loadCartList() {
    _ensureInitialized();
    try {
      final cartListFromLocal = _cartBox.values
          .map((value) => CartResponse.mapToCartResponse(value))
          .toList(growable: false);

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

  int getQuantity(int id) {
    return 10;
  }

  Future<void> removeCart(int id) async {
    _ensureInitialized();
    try {
      isLoading.value = true;

      if (!_cartBox.containsKey(id)) {
        throw const CartItemNotFoundException();
      }

      await _cartBox.delete(id);
      loadCartList();

      BaseSnackBar.showSnackBar(
        title: "Thành công",
        content: "Sản phẩm trong giỏ hàng đã được xóa thành công",
        color: Colors.green,
      );
    } on CartItemNotFoundException catch (e) {
      BaseSnackBar.showSnackBar(
        title: 'Không tìm thấy sản phẩm',
        content: e.message,
        color: Colors.red,
      );

      loadCartList();
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

  Future<void> decreaseCart(int id) async {
    _ensureInitialized();
    try {
      isLoading.value = true;

      final current = _cartBox.get(id);

      if (current == null) {
        throw const CartItemNotFoundException();
      }

      if (current.quantity <= 1) {
        await _cartBox.delete(id);
        loadCartList();
        return;
      }

      await _cartBox.put(id, current.copyWith(quantity: current.quantity - 1));

      loadCartList();
    } on CartItemNotFoundException catch (e) {
      BaseSnackBar.showSnackBar(
        title: 'Không tìm thấy sản phẩm',
        content: e.message,
        color: Colors.red,
      );

      loadCartList();
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
    _ensureInitialized();
    try {
      final current = _cartBox.get(id);

      if (current == null) {
        throw const CartItemNotFoundException();
      }

      if (current.stock <= 0 || current.quantity >= current.stock) {
        throw const CartOutOfStockException();
      }

      await _cartBox.put(id, current.copyWith(quantity: current.quantity + 1));

      loadCartList();
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

      loadCartList();
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

  Future<void> clearCart() async {
    _ensureInitialized();
    try {
      await _cartBox.clear();
    } catch (e) {
      BaseSnackBar.showSnackBar(
        title: 'Lỗi',
        content: e.toString().replaceAll("Exception: ", ""),
        color: Colors.red,
      );
    }
  }

  Future<void> addToCart(CartRequest cartRequest) async {
    _ensureInitialized();

    if (cartRequest.id <= 0) {
      throw const CartException('ID sản phẩm không hợp lệ');
    }

    if (cartRequest.stock <= 0) {
      throw const CartOutOfStockException();
    }

    if (cartRequest.quantity <= 0) {
      throw const CartException('Số lượng sản phẩm phải lớn hơn 0');
    }
    final currentCart = _cartBox.get(cartRequest.id);
    if (currentCart != null) {
      final newQuantity = currentCart.quantity + cartRequest.quantity;
      if (newQuantity > currentCart.stock) {
        throw CartOutOfStockException();
      }
      await _cartBox.put(
        currentCart.id,
        cartRequest.copyWith(quantity: newQuantity),
      );
      return;
    }
    if (cartRequest.quantity > cartRequest.stock) {
      throw const CartOutOfStockException();
    }

    await _cartBox.put(cartRequest.id, cartRequest);
  }

  Future<int> countCartItem() async {
    _ensureInitialized();
    return _cartBox.length;
  }
}
