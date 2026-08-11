import 'package:prjgetxmvc/modules/category/models/category_response.dart';
import 'package:prjgetxmvc/modules/product/models/product_response.dart';

class FormProductArgument {
  final bool isEdit;
  final ProductResponse? currentProduct;
  final List<CategoryResponse> categoriesList;
  FormProductArgument({
    required this.isEdit,
    this.currentProduct,
    required this.categoriesList,
  });
}
