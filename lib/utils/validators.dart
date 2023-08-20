import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validators {
  static final RegExp _emailRegex = RegExp(
      r"^[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$");

  static bool isEmailValid(String email) {
    return email.length <= 256 && _emailRegex.hasMatch(email);
  }

  static String? validatePassword(BuildContext context, String password) {
    // Get the localized strings
    AppLocalizations l10n = AppLocalizations.of(context)!;

    // Password must be between 8 and 64 characters
    if (password.length < 8) {
      return l10n.passwordTooShort(8);
    }
    if (password.length > 64) {
      return l10n.passwordTooLong(64);
    }

    // Password must contain at least one number
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return l10n.passwordMustContainNumber;
    }
    
    return null;
  }
}
