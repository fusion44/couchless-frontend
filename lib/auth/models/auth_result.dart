import 'auth_token.dart';
import 'user.dart';

class AuthResult {
  final AuthToken jwtToken;
  final User user;

  final bool error;
  final List<String> errorMessages;

  AuthResult(
    this.jwtToken,
    this.user, {
    this.error = false,
    this.errorMessages,
  });
}
