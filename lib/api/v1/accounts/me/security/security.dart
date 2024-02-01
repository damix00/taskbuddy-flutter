import 'package:taskbuddy/api/v1/accounts/me/security/forgot_password.dart';
import 'package:taskbuddy/api/v1/accounts/me/security/sessions.dart';

class Security {
  ForgotPassword get forgotPassword => ForgotPassword();
  LoginSessions get sessions => LoginSessions();
}