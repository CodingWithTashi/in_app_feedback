class EmailConfig {
  /// added to whom we are sending this email
  /// email can be multiple in array [abc@gmail.com,test@test.com]..
  final List<String> toMailList;

  ///fetch sendGrid Token from sendgrid dashboard
  ///100 emails/day free forever
  /// check out more from https://sendgrid.com/free/
  /// generate API key from https://app.sendgrid.com/guide/integrate/langs/curl
  final String sendGridToken;

  ///"from" email has to match with send grid email, other wise email will not trigger
  ///FYI we can't set "from" email to application user since that required user email,password or
  ///token to authenticate
  final String fromMail;

  ///email subject is optional, default value will be "Feedback & Report"
  final String emailSubject;

  EmailConfig({
    required this.toMailList,
    required this.sendGridToken,
    required this.fromMail,
    this.emailSubject = "Feedback & Report",
  });
}
