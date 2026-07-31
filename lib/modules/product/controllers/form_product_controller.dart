import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final addKeyForm = GlobalKey<FormState>();
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
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = null;
    try {
      final product = ProductRequest(
        999,
        nameEditingController.text,
        codeEditingController.text,
        double.parse(priceEditingController.text),
        int.parse(stockEditingController.text),
        CategoryRequest(
          selectedCategory.value!.id,
          selectedCategory.value!.name,
        ),
        descriptionEditingController.text,
        imageEditingController.text,
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
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = null;
    try {
      final productRequest = ProductRequest(
        idProduct!,
        nameEditingController.text,
        codeEditingController.text,
        double.parse(priceEditingController.text),
        int.parse(stockEditingController.text),
        CategoryRequest(
          selectedCategory.value!.id,
          selectedCategory.value!.name,
        ),
        descriptionEditingController.text,
        imageEditingController.text,
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
