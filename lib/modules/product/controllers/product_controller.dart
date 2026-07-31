import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
import 'package:prjgetxmvc/modules/cart/controllers/cart_controller.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';

import 'package:prjgetxmvc/modules/category/models/category_response.dart';

import 'package:prjgetxmvc/modules/product/models/product_response.dart';
import 'package:prjgetxmvc/modules/product/repositories/product_repository.dart';

//
class ProductController extends GetxController {
  final ProductRepository _productRepository;

  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final isLoading = false.obs;
  final isError = false.obs;

  final productList = <ProductResponse>[];
  final categoriesList = <CategoryResponse>[].obs;
  final selectedCategory = Rx<CategoryResponse?>(null);
  final errorMessage = RxnString();
  final displayedProducts = <ProductResponse>[].obs;
  final countItem = 0.obs;
  final quantity = 1.obs;
  final formatter = NumberFormat("#,##0", "vi_VN");

  ProductResponse? intentProduct;

  int _page = 1;
  int _limit = 10;
  final isLoadingMore = false.obs;
  bool _hasMore = true;

  final ScrollController scrollController = ScrollController();
  final SearchController searchController = SearchController();

  ProductController(this._productRepository);
  @override
  void onInit() {
    super.onInit();
    _initialize();
    countCartItem();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();

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

  Future<void> removeProduct(int id) async {
    if (isLoading.value) return;
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = null;
    try {
      final response = await _productRepository.removeProduct(id);
      if (response) {
        BaseSnackBar.showSnackBar(
          title: "Thành công",
          content: "Xóa sản phẩm thành công",
          color: Colors.green,
        );

        final cartBox = Hive.box<CartRequest>("list_cart");
        if (cartBox.containsKey(id)) {
          await cartBox.delete(id);
        }
        countCartItem();
        isLoading.value = false;
        await loadProductList(reset: true);
      } else {
        throw ProductException("Không thể xóa sản phẩm");
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

  Future<bool> addToCart(
    ProductResponse productResponse, {
    required int quantity,
  }) async {
    try {
      final cartRequest = CartRequest.mapToCartRequestWithProductResponse(
        productResponse,
        quantity,
      );
      await Get.find<CartController>().addToCart(cartRequest);
      await countCartItem();
      return true;
    } on CartException catch (e) {
      BaseSnackBar.showSnackBar(
        title: "Lỗi",
        content: e.toString(),
        color: Colors.red,
      );
      return false;
    }
  }

  Future<void> countCartItem() async {
    countItem.value = await Get.find<CartController>().countCartItem();
  }

  int getQuantity(int id) {
    try {
      final listCart = Get.find<CartController>().getCartList();
      if (listCart.isEmpty) {
        throw CartItemNotFoundException();
      }
      final index = listCart.indexWhere((cart) => cart.id == id);
      if (index != -1) {
        return listCart[index].quantity;
      }
      return 0;
    } on CartItemNotFoundException {
      return 0;
    }
  }

  void logout() async {
    final authService = Get.find<AuthService>();

    await authService.clearToken();
    await Get.find<CartController>().clearCart();
    BaseSnackBar.showSnackBar(
      title: "Thành công",
      content: "Bạn đã đăng xuất thành công",
      color: Colors.green,
    );
    Get.offAllNamed(AppPage.LOGIN);
  }
}
