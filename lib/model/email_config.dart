class EmailConfig {
  /// added to whom we are sending this email
  final String toMail;

  ///fetch sendGrid Token from sendgrid dashboard
  ///100 emails/day free forever
  /// check out more from https://sendgrid.com/free/
  final String sendGridToken;

  EmailConfig({required this.toMail, required this.sendGridToken});
}
