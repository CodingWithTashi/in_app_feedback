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

  /// title of bottom sheet
  final String title;

  /// subtitle of bottom sheet
  final String subTitle;

  /// Bottom Sheet Content Widget
  const FeedbackBottomSheet({
    Key? key,
    required this.feedbackCallback,
    this.emailConfig,
    this.gitHubConfig,
    required this.title,
    required this.subTitle,
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

  /// Global form key
  final formKey = GlobalKey<FormState>();

  /// check if submitting
  bool isSubmitting = false;
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
      key: formKey,
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
                enabledDropDown: !isSubmitting,
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

  /// bottom sheet label widget
  Widget _feedbackLabel() => Center(
        child: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );

  /// bottom sheet sub label widget
  Widget _feedbackSubLabel() => Center(
        child: Text(
          widget.subTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );

  /// bottom sheet title widget
  Widget _feedbackTitleField() => TextFormField(
        enabled: !isSubmitting,
        controller: titleController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(contentPadding),
          border: OutlineInputBorder(),
          label: Text(
            'Enter title',
          ),
        ),
        validator: (value) {
          if (value == null || !((value.length > 5) && value.isNotEmpty)) {
            return "At least 5 characters is required!";
          }
          return null;
        },
      );

  /// bottom sheet description widget

  Widget _feedbackDescriptionField() => TextFormField(
        enabled: !isSubmitting,
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
          if (value == null || !((value.length > 10) && value.isNotEmpty)) {
            return "At least 10 characters is required!";
          }
          return null;
        },
        //maxLines: 4,
        minLines: null,
        maxLines: 3,
      );

  /// bottom sheet user email TextField widget
  Widget _emailTextField() => TextFormField(
        enabled: !isSubmitting,
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

  /// bottom sheet feedback Action Button widget
  Widget _feedbackActionButton() {
    if (isSubmitting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
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
    final isValidForm = formKey.currentState?.validate();

    if (isValidForm != null && isValidForm == true) {
      FeedbackContent feedbackContent = FeedbackContent(
          userEmail: emailController.text,
          title: titleController.text,
          description: descriptionController.text);
      if (selectedIssueOption.value == kBoth) {
        _updateState(submitting: true);
        FeedbackData mailData = await SendGridHelper.sendMail(
          emailConfig: widget.emailConfig!,
          feedbackContent: feedbackContent,
        );

        await GitHubHelper.createIssue(
          gitHubConfig: widget.gitHubConfig!,
          feedbackContent: feedbackContent,
        );
        _updateState(submitting: false);
        widget.feedbackCallback(mailData);
      } else {
        if (selectedIssueOption.value == kEmail) {
          _updateState(submitting: true);
          SendGridHelper.sendMail(
            emailConfig: widget.emailConfig!,
            feedbackContent: feedbackContent,
          ).then((result) {
            _updateState(submitting: false);
            widget.feedbackCallback(result);
          });
        }
        if (selectedIssueOption.value == kGithub) {
          _updateState(submitting: true);
          GitHubHelper.createIssue(
            gitHubConfig: widget.gitHubConfig!,
            feedbackContent: feedbackContent,
          ).then((result) {
            _updateState(submitting: false);
            widget.feedbackCallback(result);
          });
        }
      }
    }
  }

  /// Update progress state
  void _updateState({required bool submitting}) {
    setState(() {
      isSubmitting = submitting;
    });
  }
}
