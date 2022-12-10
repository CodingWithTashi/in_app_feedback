class EmailConfig {
  /// added to whom we are sending this email
  /// email can be multiple in array [abc@gmail.com,test@test.com]..
  final List<String> _toMailList;

  /// fetch sendGrid Token from sendgrid dashboard
  /// 100 emails/day free forever
  /// check out more from https://sendgrid.com/free/
  /// generate API key from https://app.sendgrid.com/guide/integrate/langs/curl
  final String _sendGridToken;

  ///"from" email should to match with send grid email, other wise email will not trigger
  ///FYI we can't set "from" email to application user since that required user email,password or
  ///token to authenticate
  final String _fromMail;

  ///email subject is optional, default value will be "Feedback & Report"
  final String _emailSubject;

  EmailConfig({
    required List<String> toMailList,
    required String sendGridToken,
    required String fromMail,
    String emailSubject = "Feedback & Report",
  })  : _toMailList = toMailList,
        _sendGridToken = sendGridToken,
        _fromMail = fromMail,
        _emailSubject = emailSubject;

  String get emailSubject => _emailSubject;

  String get fromMail => _fromMail;

  String get sendGridToken => _sendGridToken;

  List<String> get toMailList => _toMailList;
}
