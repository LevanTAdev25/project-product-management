import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/base/base_dialog.dart';
import 'package:prjgetxmvc/cores/base/base_product_form.dart';
import 'package:prjgetxmvc/modules/product/controllers/form_product_controller.dart';

//
class FormProductPage extends GetView<FormProductController> {
  @override
  Widget build(BuildContext context) {
    final isEditProduct = Get.arguments['isEdit'];
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
          isEditProduct ? "Sửa thông tin sản phẩm" : "Thêm thông tin sản phẩm",
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
                child: BaseForm(baseFormState: controller.isLoading.value),
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
                    : isEditProduct == false
                    ? () async {
                        await controller.addProduct();
                      }
                    : () async {
                        await controller.updateProduct();
                      },
                child: Text(
                  isEditProduct == false ? "Thêm sản phẩm" : "Sửa sản phẩm",
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
