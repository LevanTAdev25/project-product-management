import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/routes/page_app.dart';
import 'package:prjgetxmvc/modules/splash/repositories/splash_repository.dart';

//
class SplashController extends GetxController {
  final SplashRepository _splashRepository;
  SplashController(this._splashRepository);
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if (isLoggedIn()) {
      Get.offNamed(AppPage.PRODUCTS);
    } else {
      Get.offNamed(AppPage.LOGIN);
    }
  }

  bool isLoggedIn() {
    return _splashRepository.isLoggedIn();
  }
}
