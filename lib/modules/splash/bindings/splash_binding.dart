import 'package:get/get.dart';
import 'package:prjgetxmvc/modules/splash/controllers/splash_controller.dart';
import 'package:prjgetxmvc/modules/splash/repositories/splash_repository.dart';

//
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashRepository>(() => SplashRepository(Get.find()));
    Get.put<SplashController>(SplashController(Get.find()));
  }
}
