import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/routes/page_app.dart';
import 'package:prjgetxmvc/modules/cart/bindings/cart_binding.dart';
import 'package:prjgetxmvc/modules/cart/views/cart_page.dart';
import 'package:prjgetxmvc/modules/category/bindings/category_binding.dart';
import 'package:prjgetxmvc/modules/category/bindings/form_category_binding.dart';
import 'package:prjgetxmvc/modules/category/views/category_manager_page.dart';
import 'package:prjgetxmvc/modules/category/views/add_category_page.dart';
import 'package:prjgetxmvc/modules/login/bindings/login_binding.dart';
import 'package:prjgetxmvc/modules/login/views/login_page.dart';
import 'package:prjgetxmvc/modules/product/bindings/product_binding.dart';
import 'package:prjgetxmvc/modules/product/bindings/form_product_binding.dart';
import 'package:prjgetxmvc/modules/product/views/detail_product_page.dart';
import 'package:prjgetxmvc/modules/product/views/form_product_page.dart';
import 'package:prjgetxmvc/modules/product/views/product_page.dart';
import 'package:prjgetxmvc/modules/splash/bindings/splash_binding.dart';
import 'package:prjgetxmvc/modules/splash/views/splash_page.dart';

class AppRoute {
  static final initial = AppPage.initial;
  static final pages = [
    GetPage(
      name: AppRoute.initial,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppPage.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppPage.products,
      page: () => ProductPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppPage.formProduct,
      page: () => FormProductPage(),
      binding: FormProductBinding(),
    ),
    GetPage(
      name: AppPage.category,
      page: () => AddCategoryPage(),
      binding: FormCategoryBinding(),
    ),
    GetPage(
      name: AppPage.categoryManager,
      page: () => CategoryManagerPage(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: AppPage.detailProduct,
      page: () => DetailProductPage(),
      binding: ProductBinding(),
    ),
    GetPage(name: AppPage.cart, page: () => CartPage(), binding: CartBinding()),
  ];
}

//
