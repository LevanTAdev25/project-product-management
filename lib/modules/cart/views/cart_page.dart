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
          "Sản phẩm trong giỏ hàng",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 22,
          ),
        ),
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
            final product = controller.cartList.value[index];
            return Card(
              elevation: 4,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(color: Colors.green),
              ),
              child: ListTile(
                leading: CircleAvatar(
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        final productRequest = CartRequest.mapToCartRequest(
                          product,
                        );
                        controller.decreaseCart(productRequest);
                      },
                      icon: Icon(Icons.remove),
                    ),

                    Text("${product.quantity}"),

                    IconButton(
                      onPressed: () {
                        final productRequest = CartRequest.mapToCartRequest(
                          product,
                        );
                        controller.increaseCart(productRequest);
                      },
                      icon: Icon(Icons.add),
                    ),
                    IconButton(
                      onPressed: () async {
                        Get.dialog(
                          BaseDialog(
                            title: "Xác nhận",
                            content:
                                "Bạn có muốn xóa sản phẩm này ra khỏi giỏ hàng không?",
                            onPressYes: () {
                              controller.removeCart(product.id);
                            },
                          ),
                        );
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.cartList.isEmpty) {
          return const SizedBox.shrink();
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
