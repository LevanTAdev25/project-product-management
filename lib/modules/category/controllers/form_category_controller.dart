import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:prjgetxmvc/cores/base/base_snack_bar.dart';
import 'package:prjgetxmvc/cores/base/base_unauthorized.dart';
import 'package:prjgetxmvc/cores/exceptions/category_exception.dart';
import 'package:prjgetxmvc/modules/category/controllers/category_controller.dart';
import 'package:prjgetxmvc/modules/category/models/category_request.dart';
import 'package:prjgetxmvc/modules/category/repositories/category_repository.dart';
import 'package:prjgetxmvc/modules/product/controllers/product_controller.dart';

class FormCategoryController extends GetxController {
  final CategoryRepository _categoryRepository;
  final nameCategoryTextEditingController = TextEditingController();
  final keyCategoryForm = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isError = false.obs;
  final errorMessage = RxnString();
  FormCategoryController(this._categoryRepository);
  @override
  void onReady() {
    super.onReady();
    clearTextController();
  }

  @override
  void onClose() {
    nameCategoryTextEditingController.dispose();
    super.onClose();
  }

  void clearTextController() {
    nameCategoryTextEditingController.clear();
  }

  Future<void> addCategory() async {
    if (isLoading.value) return;
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = null;
    try {
      final categoryRequest = CategoryRequest(
        999,
        nameCategoryTextEditingController.text,
      );
      final response = await _categoryRepository.addCategory(categoryRequest);
      if (response != 0) {
        await Get.find<ProductController>().loadCategoriesList();
        Get.back();
        BaseSnackBar.showSnackBar(
          title: "Thành công",
          content: "Bạn đã thêm danh mục thành công",
          color: Colors.green,
        );
        isLoading.value = false;
        await Get.find<CategoryController>().getCategoriesList();
      } else {
        throw CategoryException("Không thể thêm danh mục");
      }
    } on UnauthorizedException {
      BaseUnauthorized.handleUnauthorized();
    } catch (e) {
      BaseSnackBar.showSnackBar(
        title: "Lỗi",
        content: e.toString().replaceAll("Exception: ", ""),
        color: Colors.redAccent,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
