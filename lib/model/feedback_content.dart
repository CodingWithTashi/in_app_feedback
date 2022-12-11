/// FeedbackContent class contains email, title and description
/// user will enter these detail from bottom sheet
class FeedbackContent {
  /// store user email, email is optional
  final String _userEmail;

  /// title of the feedback
  final String _title;

  /// description of the feedback
  final String _description;

  FeedbackContent(
      {required String userEmail,
      required String title,
      required String description})
      : _userEmail = userEmail,
        _title = title,
        _description = description;

  String get description => _description;

  String get title => _title;

  String get userEmail => _userEmail;
}
