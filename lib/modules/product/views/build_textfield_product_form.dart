part of 'form_product_page.dart';

extension BuildTextfieldProductForm on FormProductPage {
  Widget _buildTextFieldProductForm({
    required bool baseFormState,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BaseFormTextField(
            context: context,
            maxLength: 50,
            focusNode: controller.nameProductFocusNode,
            nextFocusNode: controller.codeProductFocusNode,
            label: "Tên sản phẩm",
            textController: controller.nameEditingController,
            emptyError: "Tên sản phẩm không được để trống",
            baseFormState: baseFormState,
          ),
          BaseFormTextField(
            context: context,
            maxLength: 30,
            focusNode: controller.codeProductFocusNode,
            nextFocusNode: controller.priceProductFocusNode,
            label: "Mã sản phẩm",
            textController: controller.codeEditingController,
            emptyError: "Mã sản phẩm không được để trống",
            baseFormState: baseFormState,
          ),

          BaseFormTextField(
            context: context,
            maxLength: 30,
            focusNode: controller.priceProductFocusNode,
            nextFocusNode: controller.stockProductFocusNode,
            label: "Giá sản phẩm",
            textController: controller.priceEditingController,
            emptyError: "Giá sản phẩm không được để trống",
            isNumber: true,
            numberError: "Nhập đúng định dạng giá tiền",
            negativeError: "Giá tiền không được bé hơn 0",
            baseFormState: baseFormState,
          ),
          BaseFormTextField(
            context: context,
            maxLength: 5,
            focusNode: controller.stockProductFocusNode,
            nextFocusNode: controller.descriptionProductFocusNode,
            label: "Số lượng sản phẩm",
            textController: controller.stockEditingController,
            emptyError: "Số lượng sản phẩm không được để trống",
            isNumber: true,
            numberError: "Nhập đúng định dạng số lượng sản phẩm",
            negativeError: "Số lượng sản phẩm không được bé hơn 0",
            baseFormState: baseFormState,
          ),

          BaseFormTextField(
            context: context,
            maxLength: 300,
            focusNode: controller.descriptionProductFocusNode,
            nextFocusNode: controller.imageProductFocusNode,
            label: "Mô tả",
            textController: controller.descriptionEditingController,
            emptyError: "Mô tả không được để trống",
            baseFormState: baseFormState,
          ),
          BaseFormTextField(
            context: context,
            maxLength: 200,
            focusNode: controller.imageProductFocusNode,
            label: "Link ảnh",
            textController: controller.imageEditingController,
            emptyError: "Link ảnh không được để trống",
            baseFormState: baseFormState,
          ),

          const SizedBox(height: 10),
          Obx(() {
            return _buildCategoryDropDown(baseFormState: baseFormState);
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryDropDown({required bool baseFormState}) {
    if (controller.categoriesList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text("Đang tải danh mục..."),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<CategoryResponse>(
          initialValue: controller.selectedCategory.value,
          isExpanded: true,
          items: controller.categoriesList.map((category) {
            return DropdownMenuItem<CategoryResponse>(
              value: category,
              child: Text(category.name),
            );
          }).toList(),
          hint: const Text("Chọn danh mục"),
          validator: (value) {
            if (value == null) {
              return "Vui lòng chọn danh mục";
            }

            return null;
          },
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
