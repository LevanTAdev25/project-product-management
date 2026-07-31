class CategoryRequest {
  final int id;
  final String name;
  CategoryRequest(this.id, this.name);
  Map<String, dynamic> toJson() {
    return ({"name": name});
  }
}
