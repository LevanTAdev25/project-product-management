import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/base/base_dialog.dart';
import 'package:prjgetxmvc/cores/routes/page_app.dart';
import 'package:prjgetxmvc/modules/category/controllers/category_controller.dart';

class CategoryManagerPage extends GetView<CategoryController> {
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
        title: const Text(
          "Quản lý danh mục",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: const CircularProgressIndicator());
        }
        if (controller.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 50, color: Colors.grey),
                Text(
                  "${controller.errorMessage.value}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.categoriesList.length,
          itemBuilder: (context, index) {
            final category = controller.categoriesList[index];
            return ListTile(
              title: Text(category.name),
              trailing: IconButton(
                onPressed: () {
                  Get.dialog(
                    BaseDialog(
                      title: "Xác nhận",
                      content: "Bạn có muốn xóa danh mục này không?",
                      onPressYes: () async {
                        await controller.deleteCategory(category);
                      },
                    ),
                  );
                },
                icon: Icon(Icons.delete),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey("add_category"),
        child: Icon(Icons.add),
        onPressed: () {
          controller.clearTextController();
          Get.toNamed(AppPage.CATEGORY);
        },
      ),
    );
  }
}
