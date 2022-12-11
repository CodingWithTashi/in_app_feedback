class Utils {
  static String? validateTitle({required String? text}) {
    if (text == null || (!(text.length > 5) && text.isNotEmpty)) {
      return "title should have at least 5 characters";
    }
    return null;
  }

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
