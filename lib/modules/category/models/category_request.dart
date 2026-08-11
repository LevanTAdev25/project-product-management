import 'package:prjgetxmvc/modules/category/models/category_response.dart';

class CategoryRequest {
  final int id;
  final String name;
  CategoryRequest({required this.id, required this.name});
  factory CategoryRequest.mapToCategoryRequest(CategoryResponse? cartResponse) {
    return CategoryRequest(
      id: cartResponse?.id ?? 0,
      name: cartResponse?.name ?? "",
    );
  }
  CategoryRequest copyWith({required int id}) {
    return CategoryRequest(id: id, name: name);
  }

  Map<String, dynamic> toJson() {
    return ({"name": name});
  }
}
