class LoginRequest {
  final String username;
  final String password;
  LoginRequest(this.username, this.password);
  static Map<String, dynamic> toJson(LoginRequest loginRequest) {
    return {
      'username': loginRequest.username,
      'password': loginRequest.password,
    };
  }
} //
