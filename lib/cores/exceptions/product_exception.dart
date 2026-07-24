class ProductException implements Exception {
  final String message;
  const ProductException(this.message);
  @override
  String toString() {
    return message;
  }
}

class ProductEmptyException extends ProductException {
  const ProductEmptyException() : super("Danh sách sản phẩm trống");
}
