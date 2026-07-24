import 'package:prjgetxmvc/cores/base/base_api.dart';
import 'package:prjgetxmvc/cores/exceptions/category_exception.dart';
import 'package:prjgetxmvc/modules/category/models/category_request.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';

class CategoryRepository {
  final BaseApi _baseApi = BaseApi();
  Future<void> addCategory(CategoryRequest categoryRequest) async {
    await _baseApi.post("/categories", data: {"name": categoryRequest.name});
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

  Future<void> deleteCategory(int id) async {
    await _baseApi.delete("/categories/$id");
  }
}
