import 'package:prjgetxmvc/cores/base/base_api.dart';
import 'package:prjgetxmvc/cores/exceptions/category_exception.dart';
import 'package:prjgetxmvc/modules/category/models/category_request.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';

class CategoryRepository {
  final BaseApi _baseApi = BaseApi();
  Future<int> addCategory(CategoryRequest categoryRequest) async {
    final response = await _baseApi.post(
      "/categories",
      data: categoryRequest.toJson(),
    );
    return (response.data["data"] as num?)?.toInt() ?? 0;
  }

  Future<List<CategoryResponse>> getCategoriesList() async {
    final response = await _baseApi.get("/categories");
    if ((response.data['data'] as List).isEmpty) {
      throw CategoryEmptyListException();
    }
    return (response.data['data'] as List)
        .map((category) => CategoryResponse.fromJson(category))
        .toList();
  }

  Future<bool> deleteCategory(int id) async {
    final response = await _baseApi.delete("/categories/$id");
    return response.data['data'] as bool? ?? false;
  }
}
