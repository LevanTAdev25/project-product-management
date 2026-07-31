class LoginResponse {
  final String token;
  LoginResponse({required this.token});
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    try {
      return LoginResponse(token: json['access_token'] as String? ?? "");
    } on FormatException catch (e) {
      throw FormatException("Parse failed: $e");
    }
  }
}
