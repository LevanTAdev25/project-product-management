class CategoryException implements Exception {
  final String message;
  const CategoryException(this.message);
  @override
  String toString() {
    return message;
  }
}

class CategoryEmptyListException extends CategoryException {
  const CategoryEmptyListException()
    : super(
        "Danh sách danh mục trống, vui lòng thêm danh mục để thao tác tiếp",
      );
}

class CategoryInProductExistedException extends CategoryException {
  const CategoryInProductExistedException()
    : super("Danh mục này đang có sản phẩm");
}
