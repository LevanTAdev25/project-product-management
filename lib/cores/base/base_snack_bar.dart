import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseSnackBar {
  static void showSnackBar({
    required String title,
    required String content,
    required Color color,
  }) {
    Get.snackbar(
      title,
      content,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }
}
