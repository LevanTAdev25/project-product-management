import 'package:dio/dio.dart';
import 'package:prjgetxmvc/cores/exceptions/unauthorized_exception.dart';

//
class BaseHandleResponse {
  static Never handleDioResponse(DioException e) {
    if (e.response?.statusCode == 401) {
      throw UnauthorizedException();
    }
    if (e.response?.statusCode == 400) {
      final message = e.response?.data['message'] ?? "Lỗi khi xử lý dữ liệu";
      throw Exception(message);
    }
    throw Exception("Lỗi khi kết nối với máy chủ");
  }
}
