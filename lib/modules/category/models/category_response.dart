import 'package:hive_flutter/hive_flutter.dart';
import 'package:prjgetxmvc/modules/category/models/category_request.dart';
part 'category_response.g.dart';

//
@HiveType(typeId: 3)
class CategoryResponse {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  CategoryResponse({required this.id, required this.name});
  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    try {
      return CategoryResponse(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? "",
      );
    } on FormatException catch (e) {
      throw FormatException("Parse failed: $e");
    }
  }
  factory CategoryResponse.mapToCategoryResponse(
    CategoryRequest categoryRequest,
  ) {
    return CategoryResponse(id: categoryRequest.id, name: categoryRequest.name);
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryResponse &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
