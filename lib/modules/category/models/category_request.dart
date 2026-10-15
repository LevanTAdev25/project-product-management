class CategoryRequest {
  final int id;
  final String name;
  CategoryRequest({required this.id, required this.name});

  CategoryRequest copyWith({required int id}) {
    return CategoryRequest(id: id, name: name);
  }

  Map<String, dynamic> toJson() {
    return ({"name": name});
  }
}
