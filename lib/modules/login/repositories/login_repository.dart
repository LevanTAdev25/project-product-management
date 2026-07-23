import 'package:dio/dio.dart';
import 'package:prjgetxmvc/cores/api/data_api_config.dart';
import 'package:prjgetxmvc/cores/base/base_handle_response.dart';
import 'package:prjgetxmvc/cores/services/auth_service.dart';
import 'package:prjgetxmvc/modules/login/models/login_request.dart';
import 'package:prjgetxmvc/modules/login/models/login_response.dart';

//
class LoginRepository {
  final AuthService _authService;
  LoginRepository(this._authService);
  Future<void> login(LoginRequest loginRequest) async {
    try {
      final loginRequestJson = LoginRequest.toJson(loginRequest);
      final response = await DataApi().dio.post(
        "/login",
        data: loginRequestJson,
      );
      if (response.data['data']['access_token'] != null) {
        final loginResponse = LoginResponse(
          loginRequest.username,
          loginRequest.password,
          response.data['data']['access_token'],
        );
        _authService.putToken(loginResponse);
      }
    } on DioException catch (e) {
      BaseHandleResponse.handleDioResponse(e);
    }
  }
}
