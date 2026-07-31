import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/base/base_snack_bar.dart';
import 'package:prjgetxmvc/cores/base/base_unauthorized.dart';
import 'package:prjgetxmvc/cores/exceptions/category_exception.dart';
import 'package:prjgetxmvc/cores/exceptions/unauthorized_exception.dart';
import 'package:prjgetxmvc/cores/params/get_pagination_params.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';
import 'package:prjgetxmvc/modules/category/repositories/category_repository.dart';
import 'package:prjgetxmvc/modules/product/controllers/product_controller.dart';
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
    await getCategoriesList();
  }

  Future<void> getCategoriesList() async {
    if (isLoading.value) return;
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = null;
    try {
      categoriesList.assignAll(await _categoryRepository.getCategoriesList());
    } on UnauthorizedException {
      BaseUnauthorized.handleUnauthorized();
    } on CategoryEmptyListException catch (e) {
      isError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
      BaseSnackBar.showSnackBar(
        title: "Lỗi",
        content: e.toString().replaceAll("Exception: ", ""),
        color: Colors.redAccent,
      );
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

  Future<void> deleteCategory(CategoryResponse categoryResponse) async {
    if (isLoading.value) return;
    isLoading.value = true;
    isError.value = false;
    try {
      final List<ProductResponse> productList = await _productRepository
          .getProductList(
            GetPaginationParams(page: 1, limit: 10, category: categoryResponse),
          );

      if (productList.isNotEmpty) {
        throw CategoryInProductExistedException();
      }
      final response = await _categoryRepository.deleteCategory(
        categoryResponse.id,
      );
      if (response) {
        await getCategoriesList();
        BaseSnackBar.showSnackBar(
          title: "Thành công",
          content: "Xóa danh mục thành công",
          color: Colors.green,
        );
        isLoading.value = false;

        await Get.find<ProductController>().loadCategoriesList();
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
