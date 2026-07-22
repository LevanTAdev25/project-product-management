import 'package:hive_flutter/hive_flutter.dart';
part 'login_response.g.dart';

@HiveType(typeId: 0)
class LoginResponse {
  @HiveField(0)
  final String username;
  @HiveField(1)
  final String password;
  @HiveField(2)
  final String token;
  LoginResponse(this.username, this.password, this.token);
}
