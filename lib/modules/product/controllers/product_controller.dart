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
import 'package:prjgetxmvc/cores/routes/page_app.dart';
import 'package:prjgetxmvc/cores/services/auth_service.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/category/models/category_request.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_response.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';
import 'package:prjgetxmvc/modules/product/models/product_request.dart';

import 'package:prjgetxmvc/modules/product/models/product_response.dart';
import 'package:prjgetxmvc/modules/product/repositories/product_repository.dart';

//
class ProductController extends GetxController {
  final ProductRepository _productRepository;
  final Box<CartRequest> _cartBox;
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final isLoading = false.obs;
  final isError = false.obs;
  final originalList = <ProductResponse>[];
  final categoriesList = <CategoryResponse>[].obs;
  final selectedCategory = Rx<CategoryResponse?>(null);
  final errorMessage = RxnString();
  final displayedProducts = <ProductResponse>[].obs;
  final countItem = 0.obs;
  final quantity = 1.obs;
  final formatter = NumberFormat("#,##0", "vi_VN");
  List<CartResponse> cartList = [];

  ProductResponse? intentProduct;

  int _page = 1;
  int _limit = 10;
  final isLoadingMore = false.obs;
  bool _hasMore = true;

  final ScrollController scrollController = ScrollController();
  final SearchController searchController = SearchController();

  ProductController(this._productRepository, this._cartBox);
  @override
  void onInit() {
    super.onInit();
    _initialize();
    countCartItem();
    getCartList();
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
    List<ProductResponse> result = displayedProducts;
    if (searchController.text.isNotEmpty) {
      result = originalList
          .where(
            (product) => product.name.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
      displayedProducts.assignAll(result);
    } else {
      displayedProducts.assignAll(originalList);
    }
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
      searchController.clear();
      if (reset) {
        selectedCategory.value = null;
      }
      final tempProductList = await _productRepository.getProductList(
        ProductRequest.query(
          page: _page,
          limit: _limit,
          category: CategoryRequest.mapToCategoryRequest(
            selectedCategory.value,
          ),
        ),
      );
      if (tempProductList.isEmpty) {
        throw ProductEmptyException();
      }
      originalList.assignAll(tempProductList);
      displayedProducts.assignAll(tempProductList);

      if (displayedProducts.length < _limit) {
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
            ProductRequest.query(
              page: nextPage,
              limit: _limit,
              category: CategoryRequest.mapToCategoryRequest(
                selectedCategory.value,
              ),
            ),
          );
      if (newProductList.isEmpty) {
        _hasMore = false;
      } else {
        displayedProducts.addAll(newProductList);
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
        cartList.removeWhere((e) => e.id == id);
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
      final currentCart = _cartBox.get(cartRequest.id);
      if (currentCart != null) {
        final newQuantity = currentCart.quantity + cartRequest.quantity;
        if (newQuantity > currentCart.stock) {
          throw CartOutOfStockException();
        }
        await _cartBox.put(
          currentCart.id,
          cartRequest.copyWith(quantity: newQuantity),
        );

        int index = cartList.indexWhere((e) => e.id == currentCart.id);
        cartList[index] = CartResponse.mapToCartResponse(
          cartRequest.copyWith(quantity: newQuantity),
        );
        return true;
      }
      await _cartBox.put(cartRequest.id, cartRequest);
      cartList.add(CartResponse.mapToCartResponse(cartRequest));
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

  void getCartList() {
    try {
      final cartListFromLocal = _cartBox.values
          .map((value) => CartResponse.mapToCartResponse(value))
          .toList(growable: false);

      cartList.assignAll(cartListFromLocal);
    } on CartException catch (e) {
      cartList.clear();

      BaseSnackBar.showSnackBar(
        title: 'Lỗi giỏ hàng',
        content: e.message,
        color: Colors.red,
      );
    } catch (e, stackTrace) {
      cartList.clear();

      debugPrint('Lỗi đọc giỏ hàng: $e');
      debugPrintStack(stackTrace: stackTrace);

      BaseSnackBar.showSnackBar(
        title: 'Lỗi',
        content: 'Không thể tải danh sách giỏ hàng',
        color: Colors.red,
      );
    }
  }

  Future<void> countCartItem() async {
    countItem.value = await _cartBox.length;
  }

  int getQuantity(int id) {
    try {
      final temptCartList = cartList;
      if (temptCartList.isEmpty) {
        throw CartItemNotFoundException();
      }
      final index = temptCartList.indexWhere((cart) => cart.id == id);
      if (index != -1) {
        return temptCartList[index].quantity;
      }
      return 0;
    } on CartItemNotFoundException {
      return 0;
    }
  }

  void logout() async {
    final authService = Get.find<AuthService>();

    await authService.clearToken();
    await _cartBox.clear();
    BaseSnackBar.showSnackBar(
      title: "Thành công",
      content: "Bạn đã đăng xuất thành công",
      color: Colors.green,
    );
    Get.offAllNamed(AppPage.LOGIN);
  }
}
