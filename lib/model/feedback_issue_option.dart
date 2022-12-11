import 'package:in_app_feedback/constant.dart';
import 'package:in_app_feedback/model/email_config.dart';
import 'package:in_app_feedback/model/github_config.dart';

class FeedbackIssueOption {
  final String _name;
  final String _value;
  FeedbackIssueOption({
    required String name,
    required String value,
  })  : _name = name,
        _value = value;

  String get value => _value;

  String get name => _name;

  static List<FeedbackIssueOption> dropDownList(
      EmailConfig? emailConfig, GitHubConfig? gitHubConfig) {
    if (emailConfig != null && gitHubConfig != null) {
      return [
        FeedbackIssueOption(name: 'Email', value: kEmail),
        FeedbackIssueOption(name: 'Github', value: kGithub),
        FeedbackIssueOption(name: 'Both', value: kBoth),
      ];
    } else {
      if (emailConfig != null) {
        return [
          FeedbackIssueOption(name: 'Email', value: kEmail),
        ];
      } else {
        return [
          FeedbackIssueOption(name: 'Github', value: kGithub),
        ];
      }
    }
  }
}
