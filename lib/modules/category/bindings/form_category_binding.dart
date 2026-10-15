import 'package:get/get.dart';
import 'package:prjgetxmvc/modules/category/controllers/form_category_controller.dart';

class FormCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormCategoryController>(
      () => FormCategoryController(Get.find()),
      fenix: true,
    );
  }
}
