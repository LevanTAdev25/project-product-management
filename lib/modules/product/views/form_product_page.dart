import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/base/base_form_text_field.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';
import 'package:prjgetxmvc/modules/product/controllers/form_product_controller.dart';
part 'build_textfield_product_form.dart';

//
class FormProductPage extends GetView<FormProductController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        title: Text(
          controller.isEditProduct
              ? "Sửa thông tin sản phẩm"
              : "Thêm thông tin sản phẩm",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              Form(
                key: controller.keyForm,
                child: _buildTextFieldProductForm(
                  baseFormState: controller.isLoading.value,
                  context: context,
                ),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 50),
                  elevation: 5,
                  shadowColor: Colors.grey,
                  backgroundColor: Colors.black,
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : controller.saveData,
                child: Text(
                  controller.isEditProduct == false
                      ? "Thêm sản phẩm"
                      : "Sửa sản phẩm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
