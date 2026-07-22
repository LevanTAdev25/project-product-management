part of 'login_page.dart';

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
              controller: controller.usernameController,
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
              controller: controller.passwordController,
              emptyError: "Mật khẩu không được để trống",
              icon: Icon(Icons.key),
              isObscure: true,
              baseFormState: controller.isLoading.value,
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
    required TextEditingController controller,
    required String emptyError,
    required Icon icon,
    required bool isObscure,
    required bool baseFormState,
  }) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        focusNode: focusNode,
        obscureText: isObscure,
        enabled: !baseFormState,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
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
        ),
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
      ),
    );
  }
}
