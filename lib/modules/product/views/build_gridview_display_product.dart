part of 'product_page.dart';

extension BuildGridviewDisplayProduct on ProductPage {
  Widget _buildGridViewDisplayProduct() {
    return GridView.builder(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.62,
      ),
      itemCount: controller.displayedProducts.length,
      itemBuilder: (context, index) {
        final product = controller.displayedProducts[index];
        return GestureDetector(
          onTap: () {
            controller.intentProduct = product;
            Get.toNamed(AppPage.detailProduct);
          },
          child: Container(
            decoration: BoxDecoration(
              color: ProductPage.bgCard,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: Image.network(
                        product.image,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 130,
                            color: Colors.grey[900],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: ProductPage.textGray,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${controller.formatter.format(product.price)}đ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(6),
                            icon: const Icon(
                              Icons.add_shopping_cart,
                              color: ProductPage.accentColor,
                              size: 20,
                            ),
                            onPressed: () {
                              controller.quantity.value = 1;
                              _buildBottomSheetAddCart(product);
                            },
                          ),
                          const SizedBox(width: 4),

                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(6),
                            icon: const Icon(
                              Icons.edit,
                              color: ProductPage.textGray,
                              size: 18,
                            ),
                            onPressed: () async {
                              final result = await Get.toNamed(
                                AppPage.formProduct,
                                arguments: FormProductArgument(
                                  isEdit: true,
                                  currentProduct: product,
                                  categoriesList: controller.categoriesList
                                      .toList(),
                                ),
                              );
                              if (result is bool && result == true) {
                                await controller.loadProductList(reset: true);
                              }
                            },
                          ),

                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(6),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                              size: 18,
                            ),
                            onPressed: () => _showDeleteDialog(product),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
