import 'package:hive_flutter/hive_flutter.dart';
part 'category_response.g.dart';

//
@HiveType(typeId: 3)
class CategoryResponse {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  CategoryResponse(this.id, this.name);
  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(json['id'], json['name']);
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
