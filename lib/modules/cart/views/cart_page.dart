import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/cores/base/base_dialog.dart';
import 'package:prjgetxmvc/modules/cart/controllers/cart_controller.dart';
import 'package:prjgetxmvc/modules/cart/models/cart_request.dart';

//
class CartPage extends GetView<CartController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Giỏ hàng",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 22,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.cartList.isEmpty) {
              return SizedBox.shrink();
            }
            return TextButton(
              onPressed: controller.toggleEditMode,
              child: Text(
                controller.isEditMode.value ? "Xong" : "Sửa",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.cartList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, color: Colors.grey),
                const Text(
                  "Không có sản phẩm nào trong giỏ hàng",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.cartList.length,
          itemBuilder: (context, index) {
            final product = controller.cartList[index];

            return Obx(() {
              final isEditMode = controller.isEditMode.value;
              final isSelected = controller.selectedProductIds.contains(
                product.id,
              );
              return Card(
                elevation: 4,
                shadowColor: Colors.grey.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide(color: Colors.green),
                ),
                child: ListTile(
                  onTap: isEditMode
                      ? () {
                          controller.toggleProductSelection(product.id);
                        }
                      : null,
                  leading: isEditMode
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (_) {
                            controller.toggleProductSelection(product.id);
                          },
                        )
                      : CircleAvatar(
                          child: Image.network(
                            product.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset("assets/images/logo.png");
                            },
                          ),
                        ),
                  title: Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${controller.priceFormatter.format(product.price * product.quantity)}đ",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: isEditMode
                      ? null
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final productRequest =
                                    CartRequest.mapToCartRequest(product);
                                await controller.decreaseCart(
                                  productRequest.id,
                                );
                              },
                              icon: Icon(Icons.remove),
                            ),

                            Text("${product.quantity}"),

                            IconButton(
                              onPressed: () async {
                                final productRequest =
                                    CartRequest.mapToCartRequest(product);
                                await controller.increaseCart(
                                  productRequest.id,
                                );
                              },
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                ),
              );
            });
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.cartList.isEmpty) {
          return const SizedBox.shrink();
        }
        if (controller.isEditMode.value) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Checkbox(
                    value: controller.isAllSelected,
                    onChanged: (_) {
                      controller.toggleSelectAll();
                    },
                  ),
                  InkWell(
                    onTap: controller.toggleSelectAll,
                    child: const Text(
                      "Chọn tất cả",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: controller.selectedProductIds.isEmpty
                        ? null
                        : () async {
                            final selectedCount =
                                controller.selectedProductIds.length;

                            final result = await Get.dialog<bool>(
                              BaseDialog(
                                title: "Xác nhận",
                                content:
                                    "Bạn có muốn xóa $selectedCount sản phẩm đã chọn không?",
                              ),
                              barrierDismissible: false,
                            );

                            if (result == true) {
                              await controller.removeSelectedProducts();
                            }
                          },
                    icon: const Icon(Icons.delete),
                    label: Text(
                      "Xóa (${controller.selectedProductIds.length})",
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tổng tiền"),
                    Text(
                      "${controller.priceFormatter.format(controller.totalPrice.value)}đ",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  // Thanh toán
                },
                child: const Text(
                  "Thanh toán",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
