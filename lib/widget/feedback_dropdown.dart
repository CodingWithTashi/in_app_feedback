import 'package:flutter/material.dart';
import 'package:in_app_feedback/constant.dart';
import 'package:in_app_feedback/model/email_config.dart';
import 'package:in_app_feedback/model/feedback_issue_option.dart';
import 'package:in_app_feedback/model/github_config.dart';

typedef OnFeedbackIssueCallback = void Function(FeedbackIssueOption);

class FeedbackDropDown extends StatelessWidget {
  final EmailConfig? emailConfig;
  final GitHubConfig? gitHubConfig;
  final OnFeedbackIssueCallback issueCallback;
  const FeedbackDropDown(
      {Key? key,
      this.emailConfig,
      this.gitHubConfig,
      required this.issueCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<FeedbackIssueOption> dropdownList =
        FeedbackIssueOption.dropDownList(emailConfig, gitHubConfig);
    FeedbackIssueOption selectedOption =
        _getSelectedOption(dropdownList: dropdownList);

    /// set default issue call back
    issueCallback(selectedOption);
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      child: DropdownButtonFormField<FeedbackIssueOption>(
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(),
        ),
        value: selectedOption,
        items: dropdownList
            .map(
              (e) => DropdownMenuItem<FeedbackIssueOption>(
                value: e,
                child: Text(
                  e.name,
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            selectedOption = value;

            /// set issue callback manually
            issueCallback(selectedOption);
          }
        },
      ),
    );
  }

  FeedbackIssueOption _getSelectedOption(
      {required List<FeedbackIssueOption> dropdownList}) {
    if (gitHubConfig != null && emailConfig != null) {
      return dropdownList.where((element) => element.value == kBoth).first;
    } else {
      if (gitHubConfig != null) {
        return dropdownList.where((element) => element.value == kGithub).first;
      } else {
        return dropdownList.where((element) => element.value == kEmail).first;
      }
    }
  }
}
