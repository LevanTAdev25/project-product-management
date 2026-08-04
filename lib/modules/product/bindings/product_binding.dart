import 'package:get/get.dart';
import 'package:prjgetxmvc/modules/product/controllers/product_controller.dart';
import 'package:prjgetxmvc/modules/product/repositories/product_repository.dart';

//
class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRepository>(() => ProductRepository());
    Get.lazyPut<ProductController>(
      () => ProductController(Get.find(), Get.find()),
      fenix: true,
    );
  }
}
