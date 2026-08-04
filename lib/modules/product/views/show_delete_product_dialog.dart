part of 'product_page.dart';

extension ShowDeleteProductDialog on ProductPage {
  void _showDeleteDialog(dynamic product) async {
    final result = await Get.dialog<bool>(
      BaseDialog(
        title: "Xác nhận xóa",
        content: "Bạn có muốn xóa sản phẩm này không?",
      ),
    );
    if (result == true) {
      await controller.removeProduct(product.id);
    }
  }
}
