class Validators {
  static final RegExp _emailRegex = RegExp(
      r"^[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$");

  static bool isEmailValid(String email) {
    return email.length <= 256 && _emailRegex.hasMatch(email);
  }
}
