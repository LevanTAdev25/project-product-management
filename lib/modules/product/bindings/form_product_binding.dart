import 'package:get/get.dart';
import 'package:prjgetxmvc/modules/product/controllers/form_product_controller.dart';

class FormProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormProductController>(
      () => FormProductController(Get.find()),
      fenix: true,
    );
  }
}
