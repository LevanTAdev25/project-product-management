import 'package:dio/dio.dart';
import 'package:prjgetxmvc/cores/interceptors/auth_request_interceptor.dart';

class DataApi {
  final Dio dio;
  static final DataApi _instance = DataApi._internal();
  DataApi._internal()
    : dio = Dio(
        BaseOptions(
          baseUrl: "http://10.0.2.2:1997/api/v1",
          receiveTimeout: Duration(seconds: 5),
          connectTimeout: Duration(seconds: 5),
        ),
      ) {
    dio.interceptors.add(AuthRequestInterceptor());
  }
  factory DataApi() {
    return _instance;
  }
}
