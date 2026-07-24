import 'package:prjgetxmvc/cores/base/base_api.dart';

import 'package:prjgetxmvc/cores/params/get_pagination_params.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';
import 'package:prjgetxmvc/modules/product/models/product_request.dart';
import 'package:prjgetxmvc/modules/product/models/product_response.dart';

//
class ProductRepository {
  final BaseApi _baseApi = BaseApi();
  Future<List<ProductResponse>> getProductList(
    GetPaginationParams getPaginationParams,
  ) async {
    final page = getPaginationParams.page;
    final limit = getPaginationParams.limit;
    final query = {'page': page, 'limit': limit};
    if (getPaginationParams.category != null) {
      query['category_id'] = getPaginationParams.category!.id;
    }
    final response = await _baseApi.get("/products", query: query);

    return response.data['data'] != null
        ? (response.data['data'] as List)
              .map((product) => ProductResponse.fromJson(product))
              .toList()
        : [];
  }

  Future<List<CategoryResponse>> getCategoriesList() async {
    final response = await _baseApi.get("/categories");
    final List<CategoryResponse> listCategory = [];
    for (final category in response.data['data']) {
      listCategory.add(CategoryResponse.fromJson(category));
    }
    return listCategory;
  }

  Future<void> addProduct(ProductRequest productRequest) async {
    final productJson = ProductRequest.toJson(productRequest);
    await _baseApi.post("/products", data: productJson);
  }

  Future<void> removeProduct(int id) async {
    await _baseApi.delete("/products/${id}");
  }

  Future<void> updateProduct(ProductRequest productRequest) async {
    final productJson = ProductRequest.toJson(productRequest);
    await _baseApi.put("/products/${productRequest.id}", data: productJson);
  }
}
