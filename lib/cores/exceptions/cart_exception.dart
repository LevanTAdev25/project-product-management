class CartException implements Exception {
  final String message;

  const CartException(this.message);

  @override
  String toString() => message;
}

class CartItemNotFoundException extends CartException {
  const CartItemNotFoundException()
    : super('Không tìm thấy sản phẩm trong giỏ hàng');
}

class CartOutOfStockException extends CartException {
  const CartOutOfStockException()
    : super('Số lượng sản phẩm đã đạt giới hạn tồn kho');
}

class CartItemAlreadyExistsException extends CartException {
  const CartItemAlreadyExistsException()
    : super('Sản phẩm đã tồn tại trong giỏ hàng');
}

class CartItemSelectedException extends CartException {
  const CartItemSelectedException()
    : super('Cần ít nhất một sản phẩm được chọn');
}

class CartStorageException extends CartException {
  const CartStorageException(super.message);
}
