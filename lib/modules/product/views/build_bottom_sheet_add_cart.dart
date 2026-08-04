part of 'product_page.dart';

extension BuildBottomSheetAddCart on ProductPage {
  void _buildBottomSheetAddCart(ProductResponse product) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(
            color: ProductPage.bgCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 4,
                decoration: BoxDecoration(
                  color: ProductPage.textGray.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ProductPage.bgPrimary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: ProductPage.textGray,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "${controller.formatter.format(product.price)}đ",
                          style: const TextStyle(
                            color: ProductPage.accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Còn lại: ${product.stock} sản phẩm",
                          style: const TextStyle(
                            color: ProductPage.textGray,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Divider(color: Color(0xFF34383D), height: 1),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Số lượng",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Obx(() {
                    return Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: ProductPage.bgPrimary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF34383D)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            constraints: const BoxConstraints(
                              minWidth: 42,
                              minHeight: 42,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: controller.quantity.value <= 1
                                ? null
                                : () {
                                    controller.quantity.value--;
                                  },
                            icon: Icon(
                              Icons.remove,
                              size: 20,
                              color: controller.quantity.value <= 1
                                  ? ProductPage.textGray.withValues(alpha: 0.4)
                                  : Colors.white,
                            ),
                          ),

                          Container(
                            width: 45,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                vertical: BorderSide(color: Color(0xFF34383D)),
                              ),
                            ),
                            child: Text(
                              "${controller.quantity.value}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          IconButton(
                            constraints: const BoxConstraints(
                              minWidth: 42,
                              minHeight: 42,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed:
                                controller.quantity.value >= product.stock
                                ? null
                                : () {
                                    controller.quantity.value++;
                                  },
                            icon: Icon(
                              Icons.add,
                              size: 20,
                              color: controller.quantity.value >= product.stock
                                  ? ProductPage.textGray.withValues(alpha: 0.4)
                                  : ProductPage.accentColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProductPage.accentColor,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: product.stock <= 0
                      ? null
                      : () async {
                          final success = await controller.addToCart(
                            product,
                            quantity: controller.quantity.value,
                          );
                          if (success) {
                            Get.back();
                          }
                          ;
                        },
                  icon: const Icon(Icons.shopping_cart_checkout, size: 21),
                  label: const Text(
                    "Thêm vào giỏ hàng",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
    );
  }
}
