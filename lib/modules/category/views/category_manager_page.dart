import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/arguments/category_argument.dart';
import 'package:prjgetxmvc/cores/routes/page_app.dart';
import 'package:prjgetxmvc/modules/category/controllers/category_controller.dart';
import 'package:prjgetxmvc/modules/category/models/category_request.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';

class CategoryManagerPage extends GetView<CategoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back(result: controller.categoriesList);
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
                onPressed: () async {
                  await controller.deleteCategory(
                    CategoryRequest(id: category.id, name: category.name),
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
        onPressed: () async {
          final result = await Get.toNamed(AppPage.category);
          if (result is! CategoryResponse) {
            debugPrint("Kiểu kết quả: ${result.runtimeType}");
            return;
          }
          controller.categoriesList.add(result);
          controller.isError.value = false;
          controller.errorMessage.value = "";
        },
      ),
    );
  }
}
