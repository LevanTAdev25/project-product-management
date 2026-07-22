import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/base/base_handle_response.dart';
import 'package:prjgetxmvc/cores/exceptions/unauthorized_exception.dart';
import 'package:prjgetxmvc/cores/routes/page_app.dart';
import 'package:prjgetxmvc/modules/login/models/login_request.dart';
import 'package:prjgetxmvc/modules/login/repositories/login_repository.dart';

class LoginController extends GetxController {
  final LoginRepository _loginRepository;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final keyLoginForm = GlobalKey<FormState>();
  final isLoading = false.obs;
  bool loginSuccess = false;

  LoginController(this._loginRepository);
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  void login() async {
    isLoading.value = true;
    try {
      final loginRequest = LoginRequest(
        usernameController.text,
        passwordController.text,
      );
      await _loginRepository.login(loginRequest);
      loginSuccess = true;
      if (loginSuccess = true) {
        Get.rawSnackbar(
          title: "Đăng nhập thành công",
          message: "Đăng nhập thành công",
          backgroundColor: Colors.green,
          borderColor: Colors.white,
        );
        Get.offAndToNamed(AppPage.PRODUCTS);
        loginSuccess = false;
      }
    } on UnauthorizedException catch (e) {
      BaseHandleResponse.handleExceptionResponse(e);
    } catch (e) {
      BaseHandleResponse.handleExceptionResponse(e);
    } finally {
      isLoading.value = false;
    }
  }
}
