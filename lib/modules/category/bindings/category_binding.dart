import 'package:get/get.dart';
import 'package:prjgetxmvc/modules/category/controllers/category_controller.dart';
import 'package:prjgetxmvc/modules/category/repositories/category_repository.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRepository>(() => CategoryRepository());
    Get.lazyPut<CategoryController>(
      () => CategoryController(Get.find(), Get.find()),
      fenix: true,
    );
  }
}
