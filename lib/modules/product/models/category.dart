import 'package:hive_flutter/hive_flutter.dart';
part 'category.g.dart';

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  Category(this.id, this.name);
  static Category fromJson(Map<String, dynamic> json) {
    return Category(json['id'], json['name']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
