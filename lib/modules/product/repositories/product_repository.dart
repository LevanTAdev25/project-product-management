import 'package:dio/dio.dart';
import 'package:prjgetxmvc/cores/api/data_api_config.dart';
import 'package:prjgetxmvc/cores/base/base_handle_response.dart';
import 'package:prjgetxmvc/cores/params/get_pagination_params.dart';
import 'package:prjgetxmvc/cores/services/cart_service.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';
import 'package:prjgetxmvc/modules/product/models/category.dart';
import 'package:prjgetxmvc/modules/product/models/product_request.dart';
import 'package:prjgetxmvc/modules/product/models/product_response.dart';

class ProductRepository {
  final CartService _cartService;
  ProductRepository(this._cartService);
  Future<List<ProductResponse>> getProductList(
    GetPaginationParams getPaginationParams,
  ) async {
    try {
      final page = getPaginationParams.page;
      final limit = getPaginationParams.limit;
      List<dynamic>? listProductFromJson;
      if (getPaginationParams.category == null) {
        final response = await DataApi().dio.get(
          "/products",
          queryParameters: {'page': page, 'limit': limit},
        );
        listProductFromJson = response.data['data'];
      } else {
        final response = await DataApi().dio.get(
          "/products",
          queryParameters: {
            'page': page,
            'limit': limit,
            'category_id': getPaginationParams.category!.id,
          },
        );
        listProductFromJson = response.data['data'];
      }
      final List<ProductResponse> listProductResponse = [];
      if (listProductFromJson != null) {
        for (final productJson in listProductFromJson) {
          listProductResponse.add(ProductResponse.fromJson(productJson));
        }
      }
      return listProductResponse;
    } on DioException catch (e) {
      BaseHandleResponse.handleDioResponse(e);
    }
  }

  Future<List<Category>> getCategoriesList() async {
    try {
      final response = await DataApi().dio.get("/categories");
      final List<Category> listCategory = [];
      for (final category in response.data['data']) {
        listCategory.add(Category.fromJson(category));
      }
      return listCategory;
    } on DioException catch (e) {
      BaseHandleResponse.handleDioResponse(e);
    }
  }

  Future<void> addProduct(ProductRequest productRequest) async {
    try {
      final productJson = ProductRequest.toJson(productRequest);
      await DataApi().dio.post("/products", data: productJson);
    } on DioException catch (e) {
      BaseHandleResponse.handleDioResponse(e);
    }
  }

  Future<void> removeProduct(int id) async {
    try {
      await DataApi().dio.delete("/products/${id}");
    } on DioException catch (e) {
      BaseHandleResponse.handleDioResponse(e);
    }
  }

  Future<void> updateProduct(ProductRequest productRequest) async {
    try {
      final productJson = ProductRequest.toJson(productRequest);
      await DataApi().dio.put(
        "/products/${productRequest.id}",
        data: productJson,
      );
    } on DioException catch (e) {
      BaseHandleResponse.handleDioResponse(e);
    }
  }

  Future<void> addToCart(CartRequest cartRequest) async {
    await _cartService.addToListCart(cartRequest);
  }

  Future<int> countCartItem() async {
    return await _cartService.getListCart().length;
  }
}
