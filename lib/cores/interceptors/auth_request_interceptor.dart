import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/services/auth_service.dart';

//
class AuthRequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authService = Get.find<AuthService>();
    final token = authService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer ${token}';
    }
    handler.next(options);
  }
}
