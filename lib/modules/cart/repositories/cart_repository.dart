import 'package:hive_flutter/hive_flutter.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_response.dart';
import 'package:prjgetxmvc/cores/exceptions/cart_exception.dart';

//
class CartRepository {
  static const String _boxName = 'list_cart';
  late final Box<CartRequest> _cartBox;
  bool _isInitialized = false;
  Future<CartRepository> init() async {
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

  Future<void> removeCart(int id) async {
    _ensureInitialized();

    try {
      if (!_cartBox.containsKey(id)) {
        throw const CartItemNotFoundException();
      }

      await _cartBox.delete(id);
    } on CartException {
      rethrow;
    } catch (e) {
      throw CartStorageException('Không thể xóa sản phẩm khỏi giỏ hàng: $e');
    }
  }

  List<CartResponse> getCartList() {
    _ensureInitialized();

    try {
      return _cartBox.values
          .map(CartResponse.mapToCartResponse)
          .toList(growable: false);
    } catch (e) {
      throw CartStorageException('Không thể đọc danh sách giỏ hàng: $e');
    }
  }

  Future<void> decreaseCart(int id) async {
    _ensureInitialized();

    try {
      final current = _cartBox.get(id);

      if (current == null) {
        throw const CartItemNotFoundException();
      }

      if (current.quantity <= 1) {
        await _cartBox.delete(id);
        return;
      }

      await _cartBox.put(id, current.copyWith(quantity: current.quantity - 1));
    } on CartException {
      rethrow;
    } catch (e) {
      throw CartStorageException('Không thể giảm số lượng sản phẩm: $e');
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
    } on CartException {
      rethrow;
    } catch (e) {
      throw CartStorageException('Không thể tăng số lượng sản phẩm: $e');
    }
  }

  Future<void> clearCart() async {
    _ensureInitialized();

    try {
      await _cartBox.clear();
    } catch (e) {
      throw CartStorageException('Không thể xóa giỏ hàng: $e');
    }
  }

  Future<void> addToCart(CartRequest cartRequest) async {
    _ensureInitialized();

    try {
      if (cartRequest.id <= 0) {
        throw const CartException('ID sản phẩm không hợp lệ');
      }

      if (cartRequest.stock <= 0) {
        throw const CartOutOfStockException();
      }

      if (cartRequest.quantity <= 0) {
        throw const CartException('Số lượng sản phẩm phải lớn hơn 0');
      }

      if (cartRequest.quantity > cartRequest.stock) {
        throw const CartOutOfStockException();
      }

      if (_cartBox.containsKey(cartRequest.id)) {
        throw const CartItemAlreadyExistsException();
      }

      await _cartBox.put(cartRequest.id, cartRequest);
    } on CartException {
      rethrow;
    } catch (e) {
      throw CartStorageException('Không thể thêm sản phẩm vào giỏ hàng: $e');
    }
  }

  Future<int> countCartItem() async {
    _ensureInitialized();
    return _cartBox.length;
  }
}
