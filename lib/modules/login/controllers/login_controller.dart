import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/base/base_handle_response.dart';
import 'package:prjgetxmvc/cores/base/base_snack_bar.dart';
import 'package:prjgetxmvc/cores/exceptions/unauthorized_exception.dart';
import 'package:prjgetxmvc/cores/routes/page_app.dart';
import 'package:prjgetxmvc/modules/login/models/login_request.dart';
import 'package:prjgetxmvc/modules/login/repositories/login_repository.dart';

//
class LoginController extends GetxController {
  final LoginRepository _loginRepository;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final keyLoginForm = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isShowPassword = false.obs;

  LoginController(this._loginRepository);
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isShowPassword.value = !isShowPassword.value;
  }

  void clearUsername() {
    usernameController.clear();
    usernameFocusNode.requestFocus();
  }

  void clearPassword() {
    passwordController.clear();
    passwordFocusNode.requestFocus();
  }

  void clearLoginForm() {
    usernameController.clear();
    passwordController.clear();
    keyLoginForm.currentState?.reset();
    usernameFocusNode.requestFocus();
  }

  void login() async {
    isLoading.value = true;
    try {
      final loginRequest = LoginRequest(
        username: usernameController.text,
        password: passwordController.text,
      );
      final token = await _loginRepository.login(loginRequest);
      if (token.isNotEmpty) {
        Get.rawSnackbar(
          title: "Đăng nhập thành công",
          message: "Đăng nhập thành công",
          backgroundColor: Colors.green,
          borderColor: Colors.white,
        );
        Get.offAndToNamed(AppPage.PRODUCTS);
      } else {
        throw Exception("Không thể đăng nhập");
      }
    } on UnauthorizedException catch (e) {
      BaseSnackBar.showSnackBar(
        title: "Thất bại",
        content: e.toString().replaceAll("Exception: ", ""),
        color: Colors.redAccent,
      );
    } catch (e) {
      BaseSnackBar.showSnackBar(
        title: "Lỗi",
        content: e.toString().replaceAll("Exception: ", ""),
        color: Colors.redAccent,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
