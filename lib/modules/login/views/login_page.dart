import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/modules/login/controllers/login_controller.dart';
part 'login_widget.dart';

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0.5,
        centerTitle: true,
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,
          fit: BoxFit.contain,
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: _buildLoginForm(context),
          ),
        ),
      ),
    );
  }
}
