part of 'product_page.dart';

extension BuildProductDrawer on ProductPage {
  Widget _buildProductDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Row(
              children: [
                CircleAvatar(child: Icon(Icons.person)),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: const Text("Xin chào cuongpc10"),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text("Quản lý danh mục"),
            onTap: () async {
              final result = await Get.toNamed(
                AppPage.CATEGORY_MANAGER,
                arguments: CategoryArgument(
                  categoriesList: controller.categoriesList.toList(),
                ),
              );
              if (result == null || result is! List<CategoryResponse>) {
                return;
              }
              controller.categoriesList.assignAll(result);
            },
          ),
          ListTile(
            title: const Text("Đăng xuất"),
            onTap: () {
              controller.logout();
            },
          ),
        ],
      ),
    );
  }
}
