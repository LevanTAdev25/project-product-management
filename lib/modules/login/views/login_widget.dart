part of 'login_page.dart';

//
extension LoginForm on LoginPage {
  Widget _buildLoginForm(BuildContext context) {
    return Obx(() {
      return Form(
        key: controller.keyLoginForm,
        child: Column(
          children: [
            const Text(
              "Chào mừng trở lại",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 8),
            _buildTextField(
              context: context,
              focusNode: controller.usernameFocusNode,
              nextFocusNode: controller.passwordFocusNode,
              label: "Tài khoản",
              textController: controller.usernameController,
              emptyError: "Tài khoản không được để trống",
              icon: Icon(Icons.person),
              isObscure: false,
              baseFormState: controller.isLoading.value,
            ),
            SizedBox(height: 8),
            _buildTextField(
              context: context,
              focusNode: controller.passwordFocusNode,
              label: "Mật khẩu",
              textController: controller.passwordController,
              emptyError: "Mật khẩu không được để trống",
              icon: Icon(Icons.key),
              isObscure: !controller.isShowPassword.value,
              baseFormState: controller.isLoading.value,

              onTogglePassword: controller.togglePasswordVisibility,
              isShowPassword: controller.isShowPassword.value,
              onSubmitted: () {
                if (controller.keyLoginForm.currentState?.validate() ?? false) {
                  controller.login();
                }
              },
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                      if (controller.keyLoginForm.currentState!.validate()) {
                        controller.login();
                      }
                    },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 50),
                backgroundColor: Colors.black, // Màu chủ đạo của nút
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Bo góc đồng bộ với ô nhập liệu
                ),
                elevation: 2,
              ),
              child: controller.isLoading.value
                  ? SizedBox(
                      width: 20,
                      height: 25,
                      child: CircularProgressIndicator(),
                    )
                  : Text("Đăng nhập"),
            ),
            const SizedBox(height: 12),

            TextButton.icon(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.clearLoginForm,
              icon: const Icon(Icons.delete_outline, color: Colors.black),
              label: const Text(
                "Xóa tất cả",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTextField({
    required BuildContext context,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String label,
    required TextEditingController textController,
    required String emptyError,
    required Icon icon,
    required bool isObscure,
    required bool baseFormState,
    VoidCallback? onTogglePassword,
    bool isShowPassword = false,
    VoidCallback? onSubmitted,
  }) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        focusNode: focusNode,
        obscureText: isObscure,
        enabled: !baseFormState,
        controller: textController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        textInputAction: nextFocusNode != null
            ? TextInputAction.next
            : TextInputAction.done,
        validator: (value) {
          if (value == null || value.isEmpty) return emptyError;
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon,
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onTogglePassword != null)
                IconButton(
                  tooltip: isShowPassword ? "Ẩn mật khẩu" : "Hiện mật khẩu",
                  onPressed: baseFormState ? null : onTogglePassword,
                  icon: Icon(
                    isShowPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
            ],
          ),
        ),
        onFieldSubmitted: (_) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else {
            FocusScope.of(context).unfocus();
            onSubmitted?.call();
          }
        },
      ),
    );
  }
}
