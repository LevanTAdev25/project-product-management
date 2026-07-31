import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/routes/page_app.dart';
import 'package:prjgetxmvc/cores/services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

//
class SplashRepository {
  final AuthService _authService;
  SplashRepository(this._authService);
  bool isLoggedIn() {
    final token = _authService.getToken();
    if (token == null || token.isEmpty) {
      return false;
    }
    final checkLogin = _authService.isLoggedIn && !JwtDecoder.isExpired(token);
    return checkLogin;
  }
}
