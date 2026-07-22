import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:prjgetxmvc/modules/product/controllers/product_controller.dart';
import 'package:prjgetxmvc/modules/product/models/category.dart';

class BaseForm extends GetView<ProductController> {
  final bool baseFormState;
  BaseForm({super.key, required this.baseFormState});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(
            context: context,
            maxLength: 50,
            focusNode: controller.nameProductFocusNode,
            nextFocusNode: controller.codeProductFocusNode,
            label: "Tên sản phẩm",
            controller: controller.nameEditingController,
            emptyError: "Tên sản phẩm không được để trống",
          ),
          _buildTextField(
            context: context,
            maxLength: 30,
            focusNode: controller.codeProductFocusNode,
            nextFocusNode: controller.priceProductFocusNode,
            label: "Mã sản phẩm",
            controller: controller.codeEditingController,
            emptyError: "Mã sản phẩm không được để trống",
          ),

          _buildTextField(
            context: context,
            maxLength: 30,
            focusNode: controller.priceProductFocusNode,
            nextFocusNode: controller.stockProductFocusNode,
            label: "Giá sản phẩm",
            controller: controller.priceEditingController,
            emptyError: "Giá sản phẩm không được để trống",
            isNumber: true,
            numberError: "Nhập đúng định dạng giá tiền",
            negativeError: "Giá tiền không được bé hơn 0",
          ),
          _buildTextField(
            context: context,
            maxLength: 5,
            focusNode: controller.stockProductFocusNode,
            nextFocusNode: controller.descriptionProductFocusNode,
            label: "Số lượng sản phẩm",
            controller: controller.stockEditingController,
            emptyError: "Số lượng sản phẩm không được để trống",
            isNumber: true,
            numberError: "Nhập đúng định dạng số lượng sản phẩm",
            negativeError: "Số lượng sản phẩm không được bé hơn 0",
          ),

          _buildTextField(
            context: context,
            maxLength: 300,
            focusNode: controller.descriptionProductFocusNode,
            nextFocusNode: controller.imageProductFocusNode,
            label: "Mô tả",
            controller: controller.descriptionEditingController,
            emptyError: "Mô tả không được để trống",
          ),
          _buildTextField(
            context: context,
            maxLength: 200,
            focusNode: controller.imageProductFocusNode,
            label: "Link ảnh",
            controller: controller.imageEditingController,
            emptyError: "Link ảnh không được để trống",
          ),

          const SizedBox(height: 10),
          Obx(() {
            return _buildCategoryDropDown();
          }),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required int maxLength,
    required String emptyError,
    required BuildContext context,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    bool isNumber = false,
    String? numberError,
    String? negativeError,
  }) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        minLines: 1,
        maxLength: maxLength,
        enabled: !baseFormState,
        controller: controller,
        focusNode: focusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: isNumber
            ? TextInputType.numberWithOptions()
            : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) return emptyError;
          if (isNumber) {
            final numValue = double.tryParse(value);
            if (numValue == null) return numberError;
            if (numValue < 0) return negativeError;
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
      ),
    );
  }

  Widget _buildCategoryDropDown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Category>(
          value:
              controller.selectedCategory.value ??
              controller.categoriesList.first,
          isExpanded: true,
          items: controller.categoriesList.map((category) {
            return DropdownMenuItem<Category>(
              value: category,
              child: Text(category.name),
            );
          }).toList(),
          onChanged: baseFormState
              ? null
              : (value) {
                  controller.selectedCategory.value = value!;
                },
        ),
      ),
    );
  }
}
