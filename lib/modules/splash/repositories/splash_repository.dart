import 'package:prjgetxmvc/cores/services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

//
class SplashRepository {
  final AuthService _authService;
  SplashRepository(this._authService);
  bool isLoggedIn() {
    final loginResponse = _authService.getToken();
    if (loginResponse == null) {
      return false;
    }
    return _authService.isLoggedIn &&
        !JwtDecoder.isExpired(loginResponse.token);
  }
}
