import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:prjgetxmvc/cores/base/base_dialog.dart';
import 'package:prjgetxmvc/cores/base/base_snack_bar.dart';
import 'package:prjgetxmvc/cores/base/base_unauthorized.dart';
import 'package:prjgetxmvc/cores/exceptions/category_exception.dart';

import 'package:prjgetxmvc/modules/category/models/category_request.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';
import 'package:prjgetxmvc/modules/category/repositories/category_repository.dart';

class FormCategoryController extends GetxController {
  final CategoryRepository _categoryRepository;
  final nameCategoryTextEditingController = TextEditingController();
  final keyCategoryForm = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isError = false.obs;
  final errorMessage = RxString("");

  FormCategoryController(this._categoryRepository);
  @override
  void onInit() {
    super.onInit();
  }

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
    isError.value = false;
    errorMessage.value = "";
    try {
      final categoryRequest = CategoryRequest(
        id: 999,
        name: nameCategoryTextEditingController.text,
      );
      if (keyCategoryForm.currentState?.validate() ?? false) {
        final result = await Get.dialog(
          BaseDialog(
            title: "Xác nhận",
            content: "Bạn có muốn thêm danh mục này không",
          ),
        );
        if (result != true) {
          return;
        }
        isLoading.value = true;

        final response = await _categoryRepository.addCategory(categoryRequest);
        if (response != 0) {
          final newCategory = CategoryResponse.mapToCategoryResponse(
            categoryRequest.copyWith(id: response),
          );

          Get.back(result: newCategory);
          BaseSnackBar.showSnackBar(
            title: "Thành công",
            content: "Bạn đã thêm danh mục thành công",
            color: Colors.green,
          );
        } else {
          throw CategoryException("Không thể thêm danh mục");
        }
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
