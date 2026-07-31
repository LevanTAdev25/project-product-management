import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:prjgetxmvc/cores/routes/page_route.dart';
import 'package:prjgetxmvc/cores/services/auth_service.dart';
import 'package:prjgetxmvc/modules/cart/controllers/cart_controller.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';

//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(CategoryResponseAdapter());
    Hive.registerAdapter(CartRequestAdapter());
    await Get.putAsync<AuthService>(
      () => AuthService().init(),
      permanent: true,
    );
    await Get.putAsync<CartController>(
      () => CartController().init(),
      permanent: true,
    );
  } catch (e, stackTrace) {
    debugPrint("Không thể khởi tạo ứng dụng: $e");
    debugPrintStack(stackTrace: stackTrace);
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
