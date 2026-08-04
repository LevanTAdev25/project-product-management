import 'package:prjgetxmvc/cores/base/base_api.dart';

import 'package:prjgetxmvc/modules/category/models/category_response.dart';
import 'package:prjgetxmvc/modules/product/models/product_request.dart';
import 'package:prjgetxmvc/modules/product/models/product_response.dart';

//
class ProductRepository {
  final BaseApi _baseApi = BaseApi();
  Future<List<ProductResponse>> getProductList(
    ProductRequest productRequest,
  ) async {
    final page = productRequest.page;
    final limit = productRequest.limit;
    final query = {'page': page, 'limit': limit};
    if (productRequest.category!.id != 0) {
      query['category_id'] = productRequest.category!.id;
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

  Future<int> addProduct(ProductRequest productRequest) async {
    final productJson = productRequest.toJson();
    final response = await _baseApi.post("/products", data: productJson);
    return (response.data["data"] as num?)?.toInt() ?? 0;
  }

  Future<bool> removeProduct(int id) async {
    final response = await _baseApi.delete("/products/${id}");
    return response.data["data"] as bool? ?? false;
  }

  Future<bool> updateProduct(ProductRequest productRequest) async {
    final productJson = productRequest.toJson();
    final response = await _baseApi.put(
      "/products/${productRequest.id}",
      data: productJson,
    );
    return response.data["data"] as bool? ?? false;
  }
}
