class CategoryRequest {
  final int id;
  final String name;
  CategoryRequest(this.id, this.name);
  static Map<String, dynamic> toJson(CategoryRequest categoryRequest) {
    return ({"name": categoryRequest.name});
  }
}
