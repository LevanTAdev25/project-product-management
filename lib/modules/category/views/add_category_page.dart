import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/modules/category/controllers/form_category_controller.dart';

class AddCategoryPage extends GetView<FormCategoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thêm danh mục",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        return Form(
          key: controller.keyCategoryForm,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                TextFormField(
                  controller: controller.nameCategoryTextEditingController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  enabled: !controller.isLoading.value,
                  decoration: InputDecoration(
                    label: const Text(
                      "Tên danh mục",
                      style: TextStyle(color: Colors.black),
                    ),
                    prefixIcon: Icon(Icons.inventory_2),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Tên danh mục không được để trống";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(200, 50)),
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          await controller.addCategory();
                        },
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(),
                        )
                      : const Text(
                          "Thêm danh mục",
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
