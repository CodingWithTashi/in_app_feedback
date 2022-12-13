import 'package:flutter/material.dart';
import 'package:in_app_feedback/constant.dart';
import 'package:in_app_feedback/model/email_config.dart';
import 'package:in_app_feedback/model/feedback_issue_option.dart';
import 'package:in_app_feedback/model/github_config.dart';

typedef OnFeedbackIssueCallback = void Function(FeedbackIssueOption);

/// Feedback dropdown widget
class FeedbackDropDown extends StatefulWidget {
  /// Email configuration
  final EmailConfig? emailConfig;

  /// GitHub configuration
  final GitHubConfig? gitHubConfig;

  /// Dropdown selected callback method
  final OnFeedbackIssueCallback issueCallback;

  ///Enable/disable dropdown base on submit state
  final bool enabledDropDown;
  const FeedbackDropDown(
      {Key? key,
      this.emailConfig,
      this.gitHubConfig,
      required this.issueCallback,
      required this.enabledDropDown})
      : super(key: key);

  @override
  State<FeedbackDropDown> createState() => _FeedbackDropDownState();
}

class _FeedbackDropDownState extends State<FeedbackDropDown> {
  List<FeedbackIssueOption> dropdownList = [];
  late FeedbackIssueOption selectedOption;
  @override
  void initState() {
    dropdownList = FeedbackIssueOption.dropDownList(
        widget.emailConfig, widget.gitHubConfig);
    selectedOption = _getSelectedOption(dropdownList: dropdownList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// set default issue call back
    widget.issueCallback(selectedOption);
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
        onChanged: widget.enabledDropDown
            ? (value) {
                if (value != null) {
                  selectedOption = value;

                  /// set issue callback manually
                  widget.issueCallback(selectedOption);
                }
              }
            : null,
      ),
    );
  }

  /// get default selected option
  FeedbackIssueOption _getSelectedOption(
      {required List<FeedbackIssueOption> dropdownList}) {
    if (widget.gitHubConfig != null && widget.emailConfig != null) {
      return dropdownList.where((element) => element.value == kBoth).first;
    } else {
      if (widget.gitHubConfig != null) {
        return dropdownList.where((element) => element.value == kGithub).first;
      } else {
        return dropdownList.where((element) => element.value == kEmail).first;
      }
    }
  }
}
