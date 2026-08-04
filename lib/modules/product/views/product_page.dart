import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/base/base_dialog.dart';
import 'package:prjgetxmvc/cores/base/base_snack_bar.dart';
import 'package:prjgetxmvc/cores/exceptions/category_exception.dart';
import 'package:prjgetxmvc/cores/routes/page_app.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_response.dart';
import 'package:prjgetxmvc/modules/category/models/category_response.dart';
import 'package:prjgetxmvc/modules/product/controllers/product_controller.dart';
import 'package:prjgetxmvc/modules/product/models/product_response.dart';
//
part 'build_chip_filter_widget.dart';
part 'show_delete_product_dialog.dart';
part 'build_bottom_sheet_add_cart.dart';
part 'build_product_drawer.dart';
part 'build_gridview_display_product.dart';

class ProductPage extends GetView<ProductController> {
  static const Color bgPrimary = Color(0xFF111416);
  static const Color bgCard = Color(0xFF1D2024);
  static const Color accentColor = Color(0xFFE2F9FF);
  static const Color textGray = Color(0xFF9EAFB8);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      appBar: AppBar(
        backgroundColor: bgPrimary,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu, color: Colors.white),
            );
          },
        ),
        title: const Text(
          "Danh sách sản phẩm",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsGeometry.only(right: 5),
            child: Obx(() {
              return Badge(
                label: Text("${controller.countItem}"),
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () async {
                    final result = await Get.toNamed(
                      AppPage.CART,
                      arguments: {'cart_list': controller.cartList.toList()},
                    );
                    if (result == null) {
                      return;
                    }
                    controller.cartList = result;
                    await controller.countCartItem();
                  },
                ),
              );
            }),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: AlignmentGeometry.directional(-1, 0),
              child: Text(
                "Thương hiệu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SearchAnchor(
            searchController: controller.searchController,
            builder: (context, searchController) {
              return SearchBar(
                controller: searchController,
                padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                hintText: "Tìm kiếm sản phẩm",
                onChanged: controller.searchProduct,
                leading: Icon(Icons.search),
              );
            },
            suggestionsBuilder: (context, searchController) {
              final keyword = searchController.text.toLowerCase();
              final result = controller.productList.where((product) {
                return product.name.toLowerCase().contains(keyword);
              });
              return result.map((product) {
                return ListTile(
                  title: Text(product.name),
                  onTap: () {
                    searchController.closeView(product.name);
                    controller.searchProduct(product.name);
                  },
                );
              });
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 45,
            child: Obx(() {
              return ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterChip(
                    title: "Tất cả",
                    isSelected: controller.selectedCategory.value == null,
                    onTap: () async {
                      controller.selectedCategory.value = null;
                      await controller.loadProductList(reset: true);
                    },
                  ),

                  ...controller.categoriesList.map((category) {
                    final isSelected =
                        controller.selectedCategory.value?.id == category.id;
                    return _buildFilterChip(
                      title: category.name,
                      isSelected: isSelected,
                      onTap: () async {
                        controller.searchController.clear();
                        controller.selectedCategory.value = category;
                        await controller.loadProductList();
                      },
                    );
                  }),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: accentColor),
                );
              }
              if (controller.isError.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                      Text(
                        "${controller.errorMessage.value}",
                        style: TextStyle(
                          color: textGray,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                key: controller.refreshIndicatorKey,
                onRefresh: controller.handleRefresh,
                child: Stack(
                  children: [
                    _buildGridViewDisplayProduct(),
                    Obx(() {
                      if (!controller.isLoadingMore.value) {
                        return const SizedBox();
                      }

                      return const Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey("add_product"),
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
        onPressed: () {
          try {
            if (controller.categoriesList.isEmpty) {
              throw CategoryEmptyListException();
            }
            Get.toNamed(
              AppPage.FORM_PRODUCT,
              arguments: {
                "isEdit": false,
                "categories_list": controller.categoriesList.toList(),
              },
            );
          } catch (e) {
            BaseSnackBar.showSnackBar(
              title: "Lỗi",
              content: e.toString().replaceAll("Exception: ", ""),
              color: Colors.redAccent,
            );
          }
        },
        child: Icon(Icons.add),
      ),
      drawer: _buildProductDrawer(),
    );
  }
}
