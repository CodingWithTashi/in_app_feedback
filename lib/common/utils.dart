/// Utility class
/// includes method such as validate string,email etc
class Utils {
  /// validate your email using regular expression
  static bool isValidEmail(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      RegExp regExp = RegExp(pattern);

      return regExp.hasMatch(value);
    }
    return true;
  }
}
