import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prjgetxmvc/cores/base/base_snack_bar.dart';
import 'package:prjgetxmvc/cores/base/base_unauthorized.dart';
import 'package:prjgetxmvc/cores/exceptions/cart_exception.dart';
import 'package:prjgetxmvc/cores/exceptions/category_exception.dart';
import 'package:prjgetxmvc/cores/exceptions/product_exception.dart';
import 'package:prjgetxmvc/cores/exceptions/unauthorized_exception.dart';
import 'package:prjgetxmvc/cores/params/get_pagination_params.dart';
import 'package:prjgetxmvc/cores/routes/page_app.dart';
import 'package:prjgetxmvc/cores/services/auth_service.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/cart/repositories/cart_repository.dart';
import 'package:prjgetxmvc/modules/category/models/category_request.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';
import 'package:prjgetxmvc/modules/product/models/product_request.dart';
import 'package:prjgetxmvc/modules/product/models/product_response.dart';
import 'package:prjgetxmvc/modules/product/repositories/product_repository.dart';

//
class ProductController extends GetxController {
  final ProductRepository _productRepository;
  final CartRepository _cartRepository;
  final addKeyForm = GlobalKey<FormState>();
  final updateKeyForm = GlobalKey<FormState>();
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final isLoading = false.obs;
  final isError = false.obs;

  final productList = <ProductResponse>[];
  final categoriesList = <CategoryResponse>[].obs;
  final selectedCategory = Rx<CategoryResponse?>(null);
  final errorMessage = RxnString();
  final displayedProducts = <ProductResponse>[].obs;
  final countItem = 0.obs;
  final formatter = NumberFormat("#,##0", "vi_VN");
  ProductResponse? intentProduct;

  int? idProduct;
  int _page = 1;
  int _limit = 10;
  final isLoadingMore = false.obs;
  bool _hasMore = true;

  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController codeEditingController = TextEditingController();
  final TextEditingController priceEditingController = TextEditingController();
  final TextEditingController stockEditingController = TextEditingController();
  final TextEditingController descriptionEditingController =
      TextEditingController();
  final TextEditingController imageEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final SearchController searchController = SearchController();
  final nameProductFocusNode = FocusNode();
  final codeProductFocusNode = FocusNode();
  final priceProductFocusNode = FocusNode();
  final stockProductFocusNode = FocusNode();
  final descriptionProductFocusNode = FocusNode();
  final imageProductFocusNode = FocusNode();
  ProductController(this._productRepository, this._cartRepository);
  @override
  void onInit() {
    super.onInit();
    _initialize();
    countCartItem();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    nameEditingController.dispose();
    codeEditingController.dispose();
    priceEditingController.dispose();
    stockEditingController.dispose();
    descriptionEditingController.dispose();
    imageEditingController.dispose();
    scrollController.dispose();
    searchController.dispose();
    nameProductFocusNode.dispose();
    codeProductFocusNode.dispose();
    priceProductFocusNode.dispose();
    stockProductFocusNode.dispose();
    descriptionProductFocusNode.dispose();
    imageProductFocusNode.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMoreProduct();
    }
  }

  void _initialize() async {
    await loadCategoriesList();
    await loadProductList();
  }

  void applyFilter() async {
    Iterable<ProductResponse> result = productList;

    if (searchController.text.isNotEmpty) {
      result = result.where(
        (product) => product.name.toLowerCase().contains(
          searchController.text.toLowerCase(),
        ),
      );
    }
    displayedProducts.assignAll(result);
  }

  void searchProduct(String _) {
    applyFilter();
  }

  Future<void> handleRefresh() async {
    _page = 1;
    _hasMore = true;
    isLoadingMore.value = false;
    if (selectedCategory.value != null) {
      await loadProductList();
      return;
    }
    await loadProductList(reset: true);
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

  Future<void> loadProductList({bool reset = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = null;
    try {
      _page = 1;
      _hasMore = true;
      isLoadingMore.value = false;
      if (reset) {
        selectedCategory.value = null;
      }
      final tempProductList = await _productRepository.getProductList(
        GetPaginationParams(
          page: _page,
          limit: _limit,
          category: selectedCategory.value,
        ),
      );
      if (tempProductList.isEmpty) {
        throw ProductEmptyException();
      }
      productList.assignAll(tempProductList);
      displayedProducts.assignAll(productList);
      if (productList.length < _limit) {
        _hasMore = false;
      }
    } on UnauthorizedException {
      BaseUnauthorized.handleUnauthorized();
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategoriesList() async {
    if (isLoading.value) return;
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = null;
    try {
      categoriesList.assignAll(await _productRepository.getCategoriesList());
      if (categoriesList.isEmpty) {
        throw CategoryEmptyListException();
      }
    } on UnauthorizedException {
      BaseUnauthorized.handleUnauthorized();
    } catch (e) {
      BaseSnackBar.showSnackBar(
        title: "Lỗi",
        content: e.toString().replaceAll("Exception", ""),
        color: Colors.redAccent,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loadMoreProduct() async {
    if (isLoadingMore.value || !_hasMore) return;
    isLoadingMore.value = true;
    try {
      final nextPage = _page + 1;
      final List<ProductResponse> newProductList = await _productRepository
          .getProductList(
            GetPaginationParams(
              page: nextPage,
              limit: _limit,
              category: selectedCategory.value,
            ),
          );
      if (newProductList.isEmpty) {
        _hasMore = false;
      } else {
        productList.addAll(newProductList);
        applyFilter();
        _page++;
        if (newProductList.length < _limit) {
          _hasMore = false;
        }
      }
    } on UnauthorizedException {
      BaseUnauthorized.handleUnauthorized();
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoadingMore.value = false;
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
      await _productRepository.addProduct(product);
      Get.back();
      BaseSnackBar.showSnackBar(
        title: "Thành công",
        content: "Thêm sản phẩm thành công",
        color: Colors.green,
      );
      isLoading.value = false;
      await loadProductList(reset: true);
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

  Future<void> removeProduct(int id) async {
    if (isLoading.value) return;
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = null;
    try {
      await _productRepository.removeProduct(id);
      BaseSnackBar.showSnackBar(
        title: "Thành công",
        content: "Xóa sản phẩm thành công",
        color: Colors.green,
      );
      await _cartRepository.removeCart(id);
      countCartItem();
      isLoading.value = false;
      await loadProductList(reset: true);
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
      await _productRepository.updateProduct(productRequest);
      Get.back();
      BaseSnackBar.showSnackBar(
        title: "Thành công",
        content: "Chỉnh sửa sản phẩm thành công",
        color: Colors.green,
      );
      isLoading.value = false;
      await loadProductList(reset: true);
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

  void addToCart(ProductResponse productResponse) async {
    try {
      final cartRequest = CartRequest(
        productResponse.id,
        productResponse.name,
        productResponse.code,
        productResponse.price,
        productResponse.stock,
        productResponse.category,
        productResponse.description,
        productResponse.image,
        1,
      );
      await _cartRepository.addToCart(cartRequest);
      countCartItem();
    } on CartException catch (e) {
      BaseSnackBar.showSnackBar(
        title: "Lỗi",
        content: e.toString().replaceAll("Exception", ""),
        color: Colors.red,
      );
    }
  }

  void countCartItem() async {
    countItem.value = await _cartRepository.countCartItem();
  }

  void logout() async {
    final authService = Get.find<AuthService>();

    await authService.clearToken();
    await _cartRepository.clearCart();
    BaseSnackBar.showSnackBar(
      title: "Thành công",
      content: "Bạn đã đăng xuất thành công",
      color: Colors.green,
    );
    Get.offAllNamed(AppPage.LOGIN);
  }
}
