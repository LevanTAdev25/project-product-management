import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/services/auth_service.dart';

class AuthRequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authService = Get.find<AuthService>();
    final userModelWithToken = authService.getToken();
    if (userModelWithToken != null) {
      options.headers['Authorization'] = 'Bearer ${userModelWithToken.token}';
    }
    handler.next(options);
  }
}
