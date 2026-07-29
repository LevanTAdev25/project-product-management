import 'package:prjgetxmvc/modules/category/models/category_response.dart';

//
class GetPaginationParams {
  final int page;
  final int limit;
  final CategoryResponse? category;
  GetPaginationParams({required this.page, required this.limit, this.category});
}
