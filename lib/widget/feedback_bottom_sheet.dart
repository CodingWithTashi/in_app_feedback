import 'package:flutter/material.dart';
import 'package:in_app_feedback/common/utils.dart';
import 'package:in_app_feedback/constant.dart';
import 'package:in_app_feedback/model/email_config.dart';
import 'package:in_app_feedback/model/feedback_content.dart';
import 'package:in_app_feedback/model/github_config.dart';

import '../helper/github_helper.dart';
import '../helper/send_grid_helper.dart';
import '../model/feedback_data.dart';
import '../model/feedback_issue_option.dart';
import 'feedback_dropdown.dart';

typedef OnFeedbackCallback = void Function(FeedbackData);

class FeedbackBottomSheet extends StatefulWidget {
  /// on feedback callback listener
  final OnFeedbackCallback feedbackCallback;

  /// email configuration
  final EmailConfig? emailConfig;

  /// GitHub issue configuration
  final GitHubConfig? gitHubConfig;

  /// Bottom Sheet Content Widget
  const FeedbackBottomSheet({
    Key? key,
    required this.feedbackCallback,
    this.emailConfig,
    this.gitHubConfig,
  }) : super(key: key);

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  /// title controller for feedback
  late final TextEditingController titleController;

  /// description controller for feedback
  late final TextEditingController descriptionController;

  /// user email controller [Optional]
  late final TextEditingController emailController;

  ///content padding textfield,dropdown
  static const double contentPadding = 10.0;

  /// selected issue option
  late FeedbackIssueOption selectedIssueOption;
  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxHeight = 15.0;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _feedbackLabel(),
              _feedbackSubLabel(),
              const Divider(),
              FeedbackDropDown(
                emailConfig: widget.emailConfig,
                gitHubConfig: widget.gitHubConfig,
                issueCallback: (selectedOption) =>
                    selectedIssueOption = selectedOption,
              ),
              const SizedBox(height: sizedBoxHeight),
              _feedbackTitleField(),
              const SizedBox(height: sizedBoxHeight),
              _feedbackDescriptionField(),
              const SizedBox(height: sizedBoxHeight),
              _emailTextField(),
              const Divider(),
              _feedbackActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feedbackLabel() => Center(
        child: Text(
          "Feedback & Issue",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
  Widget _feedbackSubLabel() => Center(
        child: Text(
          "We would love to hear your feedback/issue",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
  Widget _feedbackTitleField() => TextFormField(
        controller: titleController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(contentPadding),
          border: OutlineInputBorder(),
          label: Text(
            'Enter title',
          ),
        ),
        validator: (value) {
          if (value == null || (!(value.length > 5) && value.isNotEmpty)) {
            return "At least 5 characters is required!";
          }
          return null;
        },
      );

  Widget _feedbackDescriptionField() => TextFormField(
        controller: descriptionController,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(contentPadding),
          border: OutlineInputBorder(),
          alignLabelWithHint: true,
          label: Text(
            'Enter description',
          ),
        ),
        validator: (value) {
          if (value == null || (!(value.length > 10) && value.isNotEmpty)) {
            return "At least 10 characters is required!";
          }
          return null;
        },
        //maxLines: 4,
        minLines: null,
        maxLines: 3,
      );

  Widget _emailTextField() => TextFormField(
        controller: emailController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(contentPadding),
          border: OutlineInputBorder(),
          label: Text(
            'Your email (Optional)',
          ),
        ),
        validator: (value) {
          if (!Utils.isValidEmail(value)) {
            return "Please add valid email address";
          }
          return null;
        },
      );

  Widget _feedbackActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => _sendFeedback(),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('Send'),
          ),
        ),
        OutlinedButton(
          onPressed: () => widget.feedbackCallback(FeedbackData(
            status: 499,
            error: "Feedback cancelled",
          )),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('Cancel'),
          ),
        ),
      ],
    );
  }

  Future<void> _sendFeedback() async {
    FeedbackContent feedbackContent = FeedbackContent(
        userEmail: emailController.text,
        title: titleController.text,
        description: descriptionController.text);
    if (isValidData(feedbackContent)) {
      if (selectedIssueOption.value == kBoth) {
        FeedbackData mailData = await SendGridHelper.sendMail(
          emailConfig: widget.emailConfig!,
          feedbackContent: feedbackContent,
        );

        await GitHubHelper.createIssue(
          gitHubConfig: widget.gitHubConfig!,
          feedbackContent: feedbackContent,
        );
        widget.feedbackCallback(mailData);
      } else {
        if (selectedIssueOption.value == kEmail) {
          SendGridHelper.sendMail(
            emailConfig: widget.emailConfig!,
            feedbackContent: feedbackContent,
          ).then((result) => widget.feedbackCallback(result));
        }
        if (selectedIssueOption.value == kGithub) {
          GitHubHelper.createIssue(
            gitHubConfig: widget.gitHubConfig!,
            feedbackContent: feedbackContent,
          ).then((result) => widget.feedbackCallback(result));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Title and description is required')));
    }
  }

  bool isValidData(FeedbackContent feedbackContent) =>
      feedbackContent.title.trim().isNotEmpty &&
      feedbackContent.description.trim().isNotEmpty;
}
