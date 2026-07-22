import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prjgetxmvc/cores/exceptions/unauthorized_exception.dart';
import 'package:get/get.dart';

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

  static void handleExceptionResponse(Object e) {
    final message = e.toString().replaceAll("Exception: ", "");
    Get.snackbar(
      "Đăng nhập thất bại",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
