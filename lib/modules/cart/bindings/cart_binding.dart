import 'package:get/get.dart';
import 'package:prjgetxmvc/modules/cart/controllers/cart_controller.dart';
import 'package:prjgetxmvc/modules/cart/repositories/cart_repository.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartRepository>(() => CartRepository(Get.find()));
    Get.lazyPut<CartController>(() => CartController(Get.find()), fenix: true);
  }
}
