import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prjgetxmvc/modules/login/models/login_response.dart';

//
class AuthService extends GetxService {
  late Box<LoginResponse> _authBox;
  bool isLoggedIn = false;
  Future<AuthService> init() async {
    _authBox = await Hive.openBox<LoginResponse>("session");
    if (getToken() != null) {
      isLoggedIn = true;
    }
    return this;
  }

  LoginResponse? getToken() {
    return _authBox.get("access_token");
  }

  Future<void> putToken(LoginResponse loginResponse) async {
    await _authBox.put("access_token", loginResponse);
    isLoggedIn = true;
  }

  Future<void> clearToken() async {
    await _authBox.clear();
    isLoggedIn = false;
  }
}
