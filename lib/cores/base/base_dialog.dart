import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function onPressYes;
  BaseDialog({
    required this.title,
    required this.content,
    required this.onPressYes,
  });
  static const Color textGray = Color(0xFF9EAFB8);
  static const Color bgCard = Color(0xFF1D2024);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: bgCard,
      title: Text(title, style: TextStyle(color: Colors.white)),
      content: Text(content, style: TextStyle(color: textGray)),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Không", style: TextStyle(color: textGray)),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            onPressYes();
          },
          child: const Text("Có", style: TextStyle(color: Colors.redAccent)),
        ),
      ],
    );
  }
}
