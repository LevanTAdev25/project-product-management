import 'package:get/get.dart';
import 'package:prjgetxmvc/modules/login/controllers/login_controller.dart';
import 'package:prjgetxmvc/modules/login/repositories/login_repository.dart';

//
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRepository>(() => LoginRepository(Get.find()));
    Get.put<LoginController>(LoginController(Get.find()));
  }
}
