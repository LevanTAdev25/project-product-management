import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:prjgetxmvc/cores/routes/page_route.dart';
import 'package:prjgetxmvc/cores/services/auth_service.dart';
import 'package:prjgetxmvc/cores/services/cart_service.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/login/models/login_response.dart';
import 'package:prjgetxmvc/modules/product/models/category.dart';

//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(LoginResponseAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(CartRequestAdapter());
    await Get.putAsync<AuthService>(
      () => AuthService().init(),
      permanent: true,
    );
    await Get.putAsync<CartService>(
      () => CartService().init(),
      permanent: true,
    );
  } catch (e) {
    return;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoute.INITIAL,
      getPages: AppRoute.pages,
    );
  }
}
