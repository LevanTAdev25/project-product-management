import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/arguments/category_argument.dart';
import 'package:prjgetxmvc/cores/base/base_dialog.dart';
import 'package:prjgetxmvc/cores/base/base_snack_bar.dart';
import 'package:prjgetxmvc/cores/base/base_unauthorized.dart';
import 'package:prjgetxmvc/cores/exceptions/category_exception.dart';
import 'package:prjgetxmvc/cores/exceptions/unauthorized_exception.dart';
import 'package:prjgetxmvc/modules/category/models/category_request.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';
import 'package:prjgetxmvc/modules/category/repositories/category_repository.dart';

import 'package:prjgetxmvc/modules/product/models/product_request.dart';
import 'package:prjgetxmvc/modules/product/models/product_response.dart';
import 'package:prjgetxmvc/modules/product/repositories/product_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _categoryRepository;
  final ProductRepository _productRepository;
  final isLoading = false.obs;
  final isError = false.obs;
  final errorMessage = RxnString();
  final categoriesList = <CategoryResponse>[].obs;
  CategoryController(this._categoryRepository, this._productRepository);
  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void initialize() async {
    getCategoriesList();
  }

  void getCategoriesList() {
    if (isLoading.value) return;
    if (Get.arguments is! CategoryArgument) {
      throw Exception("Dữ liệu không hợp lệ");
    }
    final arguments = Get.arguments as CategoryArgument;
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = null;
    try {
      if (arguments.categoriesList.isEmpty) {
        throw CategoryEmptyListException();
      }
      categoriesList.assignAll(arguments.categoriesList);
    } on UnauthorizedException {
      BaseUnauthorized.handleUnauthorized();
    } on CategoryEmptyListException catch (e) {
      isError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(CategoryRequest categoryRequest) async {
    if (isLoading.value) return;

    isError.value = false;
    errorMessage.value = null;
    try {
      final result = await Get.dialog(
        BaseDialog(
          title: "Xác nhận",
          content: "Bạn có muốn xóa danh mục này không?",
        ),
      );
      if (result != true) {
        return;
      }
      final List<ProductResponse> productList = await _productRepository
          .getProductList(
            ProductRequest.query(page: 1, limit: 10, category: categoryRequest),
          );

      if (productList.isNotEmpty) {
        throw CategoryInProductExistedException();
      }

      isLoading.value = true;
      final response = await _categoryRepository.deleteCategory(
        categoryRequest.id,
      );
      if (response) {
        categoriesList.removeWhere((e) => e.id == categoryRequest.id);
        BaseSnackBar.showSnackBar(
          title: "Thành công",
          content: "Xóa danh mục thành công",
          color: Colors.green,
        );
        isLoading.value = false;
        if (categoriesList.isEmpty) {
          throw CategoryEmptyListException();
        }
      } else {
        throw CategoryException("Không thể xóa danh mục");
      }
    } on UnauthorizedException {
      BaseUnauthorized.handleUnauthorized();
    } on CategoryEmptyListException catch (e) {
      isError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
      BaseSnackBar.showSnackBar(
        title: "Thất bại",
        content: e.toString().replaceAll("Exception: ", ""),
        color: Colors.redAccent,
      );
    } catch (e) {
      BaseSnackBar.showSnackBar(
        title: "Thất bại",
        content: e.toString().replaceAll("Exception: ", ""),
        color: Colors.redAccent,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
