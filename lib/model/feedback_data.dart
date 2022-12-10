/// Feedback Response data class
/// This is the response data for email and github issue callback
class FeedbackData {
  /// Status of the response
  /// usually 200,201,202 for success request
  final int _status;

  /// Error data, it is nullable and initially set to null
  final String? _error;

  /// for any other response message in request can be pass through message
  /// Initially set to empty message
  final String _message;

  /// FeedbackData constructor
  /// Set the data through constructor
  FeedbackData({
    required int status,
    String? error,
    String message = '',
  })  : _status = status,
        _error = error,
        _message = message;

  String get message => _message;

  String? get error => _error;

  int get status => _status;
}
