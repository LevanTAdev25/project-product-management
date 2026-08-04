import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/base/base_dialog.dart';
import 'package:prjgetxmvc/cores/base/base_snack_bar.dart';
import 'package:prjgetxmvc/cores/base/base_unauthorized.dart';
import 'package:prjgetxmvc/cores/exceptions/product_exception.dart';
import 'package:prjgetxmvc/cores/exceptions/unauthorized_exception.dart';
import 'package:prjgetxmvc/modules/product/controllers/product_controller.dart';
import 'package:prjgetxmvc/modules/product/repositories/product_repository.dart';
import 'package:prjgetxmvc/modules/category/models/category_request.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';
import 'package:prjgetxmvc/modules/product/models/product_request.dart';
import 'package:prjgetxmvc/modules/product/models/product_response.dart';

class FormProductController extends GetxController {
  final ProductRepository _productRepository;
  final keyForm = GlobalKey<FormState>();
  final updateKeyForm = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isError = false.obs;
  final selectedCategory = Rx<CategoryResponse?>(null);
  final errorMessage = RxnString();
  int? idProduct;
  final categoriesList = <CategoryResponse>[].obs;
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController codeEditingController = TextEditingController();
  final TextEditingController priceEditingController = TextEditingController();
  final TextEditingController stockEditingController = TextEditingController();
  final TextEditingController descriptionEditingController =
      TextEditingController();
  final TextEditingController imageEditingController = TextEditingController();
  final nameProductFocusNode = FocusNode();
  final codeProductFocusNode = FocusNode();
  final priceProductFocusNode = FocusNode();
  final stockProductFocusNode = FocusNode();
  final descriptionProductFocusNode = FocusNode();
  final imageProductFocusNode = FocusNode();

  FormProductController(this._productRepository);
  @override
  void onClose() {
    nameEditingController.dispose();
    codeEditingController.dispose();
    priceEditingController.dispose();
    stockEditingController.dispose();
    descriptionEditingController.dispose();
    imageEditingController.dispose();
    nameProductFocusNode.dispose();
    codeProductFocusNode.dispose();
    priceProductFocusNode.dispose();
    stockProductFocusNode.dispose();
    descriptionProductFocusNode.dispose();
    imageProductFocusNode.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    receiveData();
  }

  void receiveData() {
    final currentProduct = Get.arguments["current_product"];
    categoriesList.value = Get.arguments["categories_list"];
    selectedCategory.value = categoriesList.first;
    updateTextEditingController(currentProduct: currentProduct);
  }

  void updateTextEditingController({ProductResponse? currentProduct}) {
    if (currentProduct == null) {
      nameEditingController.text = "";
      codeEditingController.text = "";
      priceEditingController.text = "";
      stockEditingController.text = "";
      descriptionEditingController.text = "";
      imageEditingController.text = "";
    } else {
      idProduct = currentProduct.id;
      nameEditingController.text = currentProduct.name;
      codeEditingController.text = currentProduct.code;
      priceEditingController.text = currentProduct.price.toString();
      stockEditingController.text = currentProduct.stock.toString();
      descriptionEditingController.text = currentProduct.description;
      imageEditingController.text = currentProduct.image;
      selectedCategory.value = currentProduct.category;
    }
  }

  Future<void> addProduct() async {
    if (isLoading.value) return;
    isError.value = false;
    errorMessage.value = null;
    try {
      if (keyForm.currentState!.validate()) {
        final result = await Get.dialog(
          BaseDialog(
            title: "Xác nhận thêm",
            content: "Bạn có muốn thêm sản phẩm này không?",
          ),
        );
        if (result != true) {
          return;
        }
        isLoading.value = true;
        final product = ProductRequest.create(
          id: 999,
          name: nameEditingController.text,
          code: codeEditingController.text,
          price: double.parse(priceEditingController.text),
          stock: int.parse(stockEditingController.text),
          category: CategoryRequest.mapToCartRequest(selectedCategory.value),
          description: descriptionEditingController.text,
          image: imageEditingController.text,
        );
        final response = await _productRepository.addProduct(product);
        if (response != 0) {
          Get.back();
          BaseSnackBar.showSnackBar(
            title: "Thành công",
            content: "Thêm sản phẩm thành công",
            color: Colors.green,
          );
          isLoading.value = false;
          await Get.find<ProductController>().loadProductList(reset: true);
        } else {
          throw ProductException("Không thể thêm sản phẩm");
        }
      }
    } on UnauthorizedException {
      BaseUnauthorized.handleUnauthorized();
    } catch (e) {
      BaseSnackBar.showSnackBar(
        title: "Thất bại",
        content: e.toString().replaceAll("Exception: ", ""),
        color: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct() async {
    if (isLoading.value) return;
    isError.value = false;
    errorMessage.value = null;
    try {
      if (keyForm.currentState!.validate()) {
        final result = await Get.dialog<bool>(
          BaseDialog(
            title: "Xác nhận sửa",
            content: "Bạn có muốn sửa sản phẩm này không?",
          ),
        );
        if (result != true) {
          return;
        }
        isLoading.value = true;
        final productRequest = ProductRequest.create(
          id: idProduct!,
          name: nameEditingController.text,
          code: codeEditingController.text,
          price: double.parse(priceEditingController.text),
          stock: int.parse(stockEditingController.text),
          category: CategoryRequest.mapToCartRequest(selectedCategory.value),
          description: descriptionEditingController.text,
          image: imageEditingController.text,
        );
        final response = await _productRepository.updateProduct(productRequest);
        if (response) {
          Get.back();
          BaseSnackBar.showSnackBar(
            title: "Thành công",
            content: "Chỉnh sửa sản phẩm thành công",
            color: Colors.green,
          );
          isLoading.value = false;
          await Get.find<ProductController>().loadProductList(reset: true);
        } else {
          throw ProductException("Không thể cập nhật sản phẩm");
        }
      }
    } on UnauthorizedException {
      BaseUnauthorized.handleUnauthorized();
    } catch (e) {
      BaseSnackBar.showSnackBar(
        title: "Thất bại",
        content: e.toString().replaceAll("Exception: ", ""),
        color: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
