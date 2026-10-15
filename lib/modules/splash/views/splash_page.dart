import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/modules/splash/controllers/splash_controller.dart';

//
class SplashPage extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/logo.png");
  }
}
