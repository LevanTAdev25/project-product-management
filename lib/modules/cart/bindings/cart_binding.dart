import 'package:get/get.dart';
import 'package:prjgetxmvc/modules/cart/controllers/cart_controller.dart';

//
class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController(Get.find()), fenix: true);
  }
}
